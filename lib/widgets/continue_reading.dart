import 'dart:async';

import 'package:anr/models/book_data.dart';
import 'package:anr/models/chapter.dart';
import 'package:anr/models/reader.dart';
import 'package:anr/service_locator.dart';
import 'package:anr/utils/route_paths.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class ContinueReading extends StatefulWidget {
  const ContinueReading({super.key, required this.bookData});

  final BookData? bookData;

  @override
  State<ContinueReading> createState() => _ContinueReadingState();
}

class _ContinueReadingState extends State<ContinueReading> {
  Stream<DatabaseEvent>? _stream;

  List<Chapter> get _chapters => widget.bookData?.chapters ?? List.empty(growable: false);

  Future<void> _init() async {
    if (widget.bookData is! BookData) return;
    final stream = await readingHistoryRepository.continueReading(widget.bookData!.bookItem.slug);

    setState(() {
      _stream = stream;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant ContinueReading oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.bookData != widget.bookData && _stream == null) _init();
  }

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;

    if (widget.bookData is! BookData || _stream is! Stream || _chapters.isEmpty) return const SizedBox();

    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        final event = snapshot.data;

        if (event is! DatabaseEvent) return const SizedBox();

        final continueBy = _continueBy(event);

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.read_more_rounded),
            label: Text(_textByChapter(i10n, continueBy)),
            onPressed: () {
              context.push(
                RoutePaths.reader,
                extra: Reader(
                  bookData: widget.bookData!,
                  chapterIndex: _chapters.indexOf(continueBy ?? _chapters.last),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Chapter? _continueBy(DatabaseEvent event) {
    if (!event.snapshot.exists) return null;

    final item = event.snapshot.value;

    if (item is Map) {
      final id = Chapter.idByFirebaseId(item.keys.first);
      final chapterIndex = _chapters.indexWhere((chapter) => chapter.id == id);

      if (chapterIndex < 0) return null;

      final progress = double.parse(item.values.first['progress'].toString());
      final chapter = progress > 95 && chapterIndex > 0 ? _chapters[chapterIndex - 1] : _chapters[chapterIndex];

      return chapter;
    }

    return null;
  }

  String _textByChapter(AppLocalizations i10n, Chapter? continueBy) {
    if (continueBy is Chapter) return i10n.continueReading(continueBy.chapterNumber);
    return i10n.readChapter(_chapters.last.chapterNumber);
  }
}
