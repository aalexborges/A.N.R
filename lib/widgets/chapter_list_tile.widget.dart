import 'package:A.N.R/models/book_download.model.dart';
import 'package:A.N.R/models/chapter.model.dart';
import 'package:A.N.R/store/download.store.dart';
import 'package:A.N.R/store/historic.store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ChapterListTileWidget extends StatelessWidget {
  final String bookId;
  final Chapter chapter;
  final BookDownload downloadBook;

  final void Function()? onTap;

  const ChapterListTileWidget({
    required this.bookId,
    required this.chapter,
    required this.downloadBook,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final historicStore = Provider.of<HistoricStore>(context);
    final downloadStore = Provider.of<DownloadStore>(context);

    return Material(
      color: Colors.transparent,
      child: ListTile(
        title: Text(chapter.name),
        contentPadding: const EdgeInsets.symmetric(horizontal: 32),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Observer(builder: (context) {
              final status = downloadStore.chapters[chapter.id];

              if (status == null) return const SizedBox();
              if (!status) return const Icon(Icons.downloading_rounded);

              return const Icon(Icons.download_done_rounded);
            }),
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
        onLongPress: () async {
          final downloadState = downloadStore.chapters[chapter.id];

          final action = await showModalBottomSheet<_SheetAction?>(
            context: context,
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: _DownloadOption.title(downloadState),
                  leading: _DownloadOption.icon(downloadState),
                  subtitle: _DownloadOption.subtitle(downloadState),
                  onTap: () => _DownloadOption.action(context, downloadState),
                ),
              ],
            ),
          );

          if (action == _SheetAction.ADD_TO_DOWNLOAD) {
            downloadStore.addInQueue(downloadBook, chapter).catchError((e) {
              final message = ScaffoldMessenger.of(context);

              message.clearSnackBars();
              message.showSnackBar(const SnackBar(
                content: Text(
                  'Erro ao adicionar o capítulo a fila de download',
                ),
              ));
            });
          } else if (action == _SheetAction.DELETE_TO_DOWNLOAD) {
            downloadStore.remove(chapter).catchError((e) {
              final message = ScaffoldMessenger.of(context);

              message.clearSnackBars();
              message.showSnackBar(const SnackBar(
                content: Text(
                  'Erro ao remover o capítulo da fila de download',
                ),
              ));
            });
          }
        },
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

class _DownloadOption {
  static Widget title(bool? state) {
    if (state == null) return const Text('Fazer download do capítulo');
    if (state == true) return const Text('Deletar capítulo');
    return const Text('Cancelar download do capítulo');
  }

  static Widget? subtitle(bool? state) {
    if (state != false) return null;
    return const Text('Se já iniciou o download. não será cancelado');
  }

  static Widget icon(bool? state) {
    if (state == null) return const Icon(Icons.download_rounded);
    if (state == true) return const Icon(Icons.delete_rounded);
    return const Icon(Icons.file_download_off_rounded);
  }

  static void action(BuildContext context, bool? state) {
    if (state is bool) {
      return Navigator.of(context).pop(_SheetAction.DELETE_TO_DOWNLOAD);
    }

    Navigator.of(context).pop(_SheetAction.ADD_TO_DOWNLOAD);
  }
}

enum _SheetAction {
  // ignore: constant_identifier_names
  ADD_TO_DOWNLOAD,

  // ignore: constant_identifier_names
  DELETE_TO_DOWNLOAD,
}
