import 'dart:async';

import 'package:anr/models/book.dart';
import 'package:anr/models/book_data.dart';
import 'package:anr/models/chapter.dart';
import 'package:anr/models/content.dart';
import 'package:anr/repositories/reading_history_repository.dart';
import 'package:anr/router.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class ReadButton extends StatefulWidget {
  const ReadButton({super.key, required this.book, this.data});

  final Book book;
  final BookData? data;

  @override
  State<ReadButton> createState() => _ReadButtonState();
}

class _ReadButtonState extends State<ReadButton> {
  StreamSubscription<DatabaseEvent>? _listen;
  double _continueBy = -1;

  void _next(double id) {
    if (widget.data == null) return;

    final index = widget.data!.chapters.indexWhere((e) => e.id == id);
    setState(() {
      _continueBy = index > 0 ? widget.data!.chapters[index - 1].id : id;
    });
  }

  Future<void> _init() async {
    final stream = await ReadingHistoryRepository.I.continueReading(widget.book);

    _listen = stream.listen((event) {
      final item = event.snapshot.value;

      if (item is Map) {
        final id = Chapter.firebaseIdToId(item.keys.first);
        final progress = double.parse(item.values.first.toString());

        if (progress > 95) return _next(id);
        return setState(() {
          _continueBy = id;
        });
      }

      if (widget.data != null) {
        final index = widget.data!.chapters.length - 1;
        if (index >= 0) {
          setState(() {
            _continueBy = widget.data!.chapters[index].id;
          });
        }
      }
    });
  }

  void _onPressed(BuildContext context) {
    context.push(
      ScreenPaths.content,
      extra: ContentParams(
        scan: widget.book.scan,
        chapters: widget.data!.chapters,
        startAt: widget.data!.chapters.indexWhere((e) => e.id == _continueBy),
      ),
    );
  }

  @override
  void didUpdateWidget(ReadButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.data != widget.data && _listen == null) _init();
  }

  @override
  void dispose() {
    _listen?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_continueBy < 0) return const SizedBox();

    final t = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _onPressed(context),
        icon: const Icon(Icons.read_more_rounded),
        label: Text(t.readChapter(Chapter.formatIdToChapterString(_continueBy))),
      ),
    );
  }
}
