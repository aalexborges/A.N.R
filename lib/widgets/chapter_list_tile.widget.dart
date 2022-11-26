import 'package:A.N.R/models/chapter.model.dart';
import 'package:A.N.R/store/historic.store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ChapterListTileWidget extends StatelessWidget {
  final String bookId;
  final Chapter chapter;

  final void Function()? onTap;

  const ChapterListTileWidget({
    required this.bookId,
    required this.chapter,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final historicStore = Provider.of<HistoricStore>(context);

    return Material(
      color: Colors.transparent,
      child: ListTile(
        title: Text(chapter.name),
        contentPadding: const EdgeInsets.symmetric(horizontal: 32),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Observer(builder: (context) {
              final read = historicStore.historic[bookId]?[chapter.id];
              if (read == null) return const SizedBox();

              return Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.only(left: 16),
                child: _readProgress(context, read),
              );
            }),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _readProgress(BuildContext context, double read) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            child: Icon(
              Icons.remove_red_eye_rounded,
              size: 16,
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
          ),
        ),
        Positioned.fill(
          child: CircularProgressIndicator(
            value: read / 100,
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          ),
        ),
      ],
    );
  }
}
