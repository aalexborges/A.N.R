import 'dart:async';
import 'dart:ui';

import 'package:anr/models/chapter.dart';
import 'package:anr/models/content.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/service_locator.dart';
import 'package:anr/widgets/content_item.dart';
import 'package:anr/widgets/content_item_with_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key, required this.params});

  final ContentParams params;

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  final _controller = ScrollController();
  final _items = List<Content>.empty(growable: true);

  bool _loading = true;
  bool _lastChapter = false;
  bool _nextChapterLoaded = false;
  bool _gettingNextChapter = false;
  int _currentlyChapterIndex = -1;
  int _currentlyContentIndex = -1;
  double _progress = 0;

  Scan get scan => widget.params.scan;
  List<Chapter> get chapters => widget.params.chapters;
  Chapter get currentChapter => chapters[_currentlyChapterIndex];
  Content get currentContent => _items[_currentlyContentIndex];

  @override
  void initState() {
    super.initState();

    _controller.addListener(_controllerListener);
    _loadInitialChapter();
  }

  @override
  Future<void> dispose() async {
    _controller.removeListener(_controllerListener);
    _controller.dispose();

    super.dispose();

    if (_currentlyChapterIndex >= 0 && _currentlyContentIndex >= 0 && _progress > 0) {
      try {
        await readingHistoryRepository.update(
          book: widget.params.book,
          chapter: currentChapter,
          progress: _progress,
        );
      } catch (_) {}
    }
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
                physics: _loading ? const NeverScrollableScrollPhysics() : null,
                cacheExtent: MediaQuery.of(context).size.height + 99911,
                controller: _controller,
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final content = _items[index];

                  if (index == 0) {
                    return ContentItemWithLoading(
                      key: content.key,
                      content: content,
                      headers: scan.repository.headers,
                      onLoaded: _onLoaded,
                    );
                  }

                  return ContentItem(
                    key: content.key,
                    content: content,
                    headers: scan.repository.headers,
                  );
                },
              ),
            ),
          ),
          Positioned.fill(child: _loadingBlur()),
          Positioned.fill(child: Center(child: _loading ? const CircularProgressIndicator.adaptive() : null)),
        ],
      ),
    );
  }

  Widget _loadingBlur() {
    if (!_loading) return const SizedBox();

    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(color: Theme.of(context).colorScheme.background.withOpacity(0.2)),
      ),
    );
  }

  Future<void> _onLoaded() async {
    if (_loading) await Future.delayed(const Duration(milliseconds: 250), _continueByProgress);
  }

  Future<Content> _loadChapterContent(int index) async {
    return scan.repository.content(widget.params.chapters[index]);
  }

  Future<void> _loadInitialChapter() async {
    try {
      final content = await _loadChapterContent(widget.params.chapterIndex);

      setState(() {
        _items.add(content);
        _loading = content.isImage ? true : false;
        _currentlyContentIndex = 0;
        _currentlyChapterIndex = widget.params.chapterIndex;
        _lastChapter = widget.params.chapterIndex == 0;
      });

      if (!content.isImage) await Future.delayed(const Duration(milliseconds: 250), _continueByProgress);
    } catch (e) {
      _snackBarError();
    }
  }

  Future<void> _loadNextChapter() async {
    try {
      _gettingNextChapter = true;

      final nextChapterIndex = _currentlyChapterIndex - 1;
      final content = await _loadChapterContent(nextChapterIndex);

      setState(() {
        _items.add(content);
        _nextChapterLoaded = true;
        _gettingNextChapter = false;
        _lastChapter = nextChapterIndex == 0;
      });
    } catch (e) {
      _snackBarError();
    }
  }

  Future<void> _nextChapter() async {
    final oldChapter = currentChapter;

    _nextChapterLoaded = false;
    _currentlyChapterIndex = _currentlyChapterIndex - 1;
    _currentlyContentIndex = _currentlyContentIndex + 1;
    _progress = 0;

    await readingHistoryRepository.update(book: widget.params.book, chapter: oldChapter, progress: 100);
  }

  Future<void> _continueByProgress() async {
    if (!_loading) return;

    setState(() {
      _loading = false;
    });

    final chapter = chapters[widget.params.chapterIndex];
    final progress = await readingHistoryRepository.progress(widget.params.book.slug, chapter.firebaseId);

    if (progress > 0) _controller.jumpTo((_controller.position.maxScrollExtent * progress) / 100);
  }

  Future<void> _controllerListener() async {
    _progress = currentContent.readingProgress;

    if (_nextChapterLoaded && _progress >= 100) return await _nextChapter();
    if (_lastChapter || _gettingNextChapter || _nextChapterLoaded) return;

    final nextChapterTrigger = 0.72 * _controller.position.maxScrollExtent;
    if (_controller.position.pixels > nextChapterTrigger) await _loadNextChapter();
  }

  void _snackBarError() {
    final i10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();
    messenger.showSnackBar(SnackBar(content: Text(i10n.bookContentError)));
  }
}
