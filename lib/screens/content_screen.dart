import 'dart:async';
import 'dart:ui';

import 'package:anr/models/chapter.dart';
import 'package:anr/models/content.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/repositories/reading_history_repository.dart';
import 'package:anr/widgets/content_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key, required this.params});

  final ContentParams params;

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  bool _isLoading = true;
  bool _processing = false;
  bool _lastChapter = false;

  Chapter? _currentChapter;
  Content? _currentContent;
  int? _currentChapterIndex;

  Chapter? _nextChapter;
  Content? _nextContent;
  int? _nextChapterIndex;

  double _readingProgress = 0;

  final _contents = List<Content>.empty(growable: true);
  final _controller = ScrollController();

  bool get _isProcessing => _isLoading || _processing;
  bool get _hasContent => _currentChapter != null && _currentContent != null && _currentChapterIndex != null;
  bool get _hasNextContent => _nextChapter != null && _nextContent != null && _nextChapterIndex != null;

  Future<void> _init() async {
    if (_hasContent) return;

    _currentChapterIndex = widget.params.startAt;
    _currentChapter = widget.params.chapters[_currentChapterIndex!];
    _currentContent = await widget.params.scan.repository.content(_currentChapter!);

    _readingProgress = _currentChapter!.readingProgress;
    _lastChapter = _currentChapterIndex == 0;

    setState(() {
      _contents.add(_currentContent!);
    });
  }

  Future<void> _getNext() async {
    if (_hasNextContent) return;

    _nextChapterIndex = _currentChapterIndex! - 1;
    _nextChapter = widget.params.chapters[_nextChapterIndex!];

    try {
      _nextContent = await widget.params.scan.repository.content(_nextChapter!);
    } catch (e) {
      _snackBarError(e);
      rethrow;
    }

    if (!_contents.contains(_nextContent)) {
      setState(() {
        _contents.add(_nextContent!);
      });
    }
  }

  Future<void> _next() async {
    if (!_hasNextContent) return;

    final chapter = widget.params.chapters[_currentChapterIndex!];
    final readingProgress = _readingProgress;

    _currentChapter = _nextChapter;
    _currentContent = _nextContent;
    _currentChapterIndex = _nextChapterIndex;

    _nextChapter = null;
    _nextContent = null;
    _nextChapterIndex = null;

    _readingProgress = 0;
    _lastChapter = _currentChapterIndex == 0;

    await ReadingHistoryRepository.I.update(chapter, readingProgress);
  }

  void _onFinishedLoading() {
    if (!_isLoading) return;

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _isLoading = false;
      });

      if (_currentChapter is Chapter) {
        _controller.jumpTo((_controller.position.maxScrollExtent * _currentChapter!.readingProgress) / 100);
      }
    });
  }

  Future<void> _scrollListener() async {
    if (_isProcessing) return;
    _processing = true;
    _readingProgress = _currentContent?.readingProgress ?? _readingProgress;

    if (_lastChapter) {
      _processing = false;
      return;
    }

    if (_readingProgress >= 100) {
      await _next();

      _processing = false;
      return;
    }

    final nextChapterTrigger = 0.72 * _controller.position.maxScrollExtent;
    if (_controller.position.pixels > nextChapterTrigger) await _getNext();

    _processing = false;
  }

  @override
  void initState() {
    _init().catchError(_snackBarError);
    _controller.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    if (_hasContent) {
      ReadingHistoryRepository.I.update(_currentChapter!, _readingProgress);
    }

    _controller.removeListener(_scrollListener);
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              child: ListView.builder(
                physics: _isLoading ? const NeverScrollableScrollPhysics() : null,
                cacheExtent: MediaQuery.of(context).size.height + 99901,
                controller: _controller,
                itemCount: _contents.length,
                restorationId: 'test',
                itemBuilder: (context, index) {
                  return ContentListItem(
                    key: Key(_contents[index].chapter.chapter),
                    scan: widget.params.scan,
                    content: _contents[index],
                    onFinishedLoading: index == 0 ? _onFinishedLoading : null,
                  );
                },
              ),
            ),
          ),
          Positioned.fill(child: _loadingBlur()),
          Positioned.fill(
            child: Center(
              child: _isLoading ? const CircularProgressIndicator.adaptive() : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingBlur() {
    if (!_isLoading) return const SizedBox();

    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(color: Theme.of(context).colorScheme.background.withOpacity(0.2)),
      ),
    );
  }

  FutureOr<void> _snackBarError(dynamic e) {
    final t = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();
    messenger.showSnackBar(SnackBar(content: Text(t.bookContentError)));
  }
}
