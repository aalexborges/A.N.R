import 'package:anr/models/book.dart';
import 'package:anr/models/book_data.dart';
import 'package:anr/models/chapter.dart';
import 'package:anr/models/content.dart';
import 'package:anr/repositories/reading_history_repository.dart';
import 'package:anr/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class ReadButton extends StatelessWidget {
  const ReadButton({super.key, required this.book, this.data});

  final Book book;
  final BookData? data;

  void _onPressed(BuildContext context, double continueBy) {
    context.push(
      ScreenPaths.content,
      extra: Content(
        book: book,
        chapters: data!.chapters,
        startAt: data!.chapters.indexWhere((element) => element.id == continueBy),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) return const SizedBox();

    final t = AppLocalizations.of(context)!;

    return FutureBuilder(
      future: Future(() => ReadingHistoryRepository.I.continueReading(book)),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const SizedBox();

        double continueBy = snapshot.data?.id ?? data!.chapters.last.id;

        if (snapshot.data != null && snapshot.data!.progress > 96) {
          final index = data!.chapters.indexWhere((e) => e.id == snapshot.data!.id);
          if (index != -1 && index > 0) continueBy = data!.chapters[index - 1].id;
        }

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _onPressed(context, continueBy),
            icon: const Icon(Icons.read_more_rounded),
            label: Text(t.readChapter(Chapter.formatIdToChapterString(continueBy))),
          ),
        );
      },
    );
  }
}
