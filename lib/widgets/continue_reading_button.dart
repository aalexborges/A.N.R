import 'package:anr/models/book_data.dart';
import 'package:anr/models/chapter.dart';
import 'package:anr/models/content.dart';
import 'package:anr/router.dart';
import 'package:anr/service_locator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class ContinueReadingButton extends StatefulWidget {
  const ContinueReadingButton({super.key, this.bookData});

  final BookData? bookData;

  @override
  State<ContinueReadingButton> createState() => _ContinueReadingButtonState();
}

class _ContinueReadingButtonState extends State<ContinueReadingButton> {
  Stream<DatabaseEvent>? _stream;

  List<Chapter> get _chapters => widget.bookData?.chapters ?? List.empty(growable: false);

  Future<void> _init() async {
    if (widget.bookData is! BookData) return;
    final stream = await readingHistoryRepository.continueReading(widget.bookData!.book.slug);

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
  void didUpdateWidget(covariant ContinueReadingButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.bookData != widget.bookData && _stream == null) _init();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bookData is! BookData || _stream is! Stream || _chapters.isEmpty) return const SizedBox();

    final i10n = AppLocalizations.of(context)!;

    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.data is! DatabaseEvent) return const SizedBox();

        final event = snapshot.data!;
        final continueBy = _continueBy(event);

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.read_more_rounded),
            label: Text(_textByChapter(i10n, continueBy)),
            onPressed: () {
              context.push(
                ScreenPaths.content,
                extra: ContentParams(
                  bookData: widget.bookData!,
                  chapterIndex: widget.bookData!.chapters.indexOf(continueBy ?? _chapters.last),
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
