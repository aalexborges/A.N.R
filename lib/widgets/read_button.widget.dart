import 'package:A.N.R/constants/routes_path.dart';
import 'package:A.N.R/models/book.model.dart';
import 'package:A.N.R/models/chapter.model.dart';
import 'package:A.N.R/screens/reader.screen.dart';
import 'package:A.N.R/store/historic.store.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ReadButtonWidget extends StatelessWidget {
  final Book book;
  final List<Chapter> chapters;

  const ReadButtonWidget({
    required this.book,
    required this.chapters,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) return const SizedBox();

    final store = Provider.of<HistoricStore>(context);

    return Observer(
      builder: (context) {
        final historic = store.historic[book.id];

        bool isStarting = historic == null;
        Chapter chapter = chapters.last;
        int index = chapters.length - 1;

        if (historic != null) {
          isStarting = false;

          final keys = historic.keys.toList();
          keys.sort((a, b) => compareNatural(b, a));

          final lastRead = keys.first;
          index = chapters.indexWhere((e) => e.id == lastRead);
          index = index == -1 ? 0 : index;

          final isNext = historic[lastRead]! > 96 && index >= 1;
          index = isNext ? index - 1 : index;
          chapter = chapters[index];
        }

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.read_more_rounded),
            label: Text(
              isStarting
                  ? 'Ler capítulo ${chapter.chapter}'
                  : 'Continuar leitura do capítulo ${chapter.chapter}',
            ),
            onPressed: () => context.push(
              RoutesPath.READER,
              extra: ReaderProps(
                book: book,
                chapters: chapters,
                startedIndex: index,
              ),
            ),
          ),
        );
      },
    );
  }
}
