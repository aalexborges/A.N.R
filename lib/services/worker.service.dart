import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:A.N.R/constants/ports.dart';
import 'package:A.N.R/constants/scans.dart';
import 'package:A.N.R/database/downloads_db.dart';
import 'package:A.N.R/models/content_downloaded.model.dart';
import 'package:A.N.R/models/download_notification.model.dart';
import 'package:A.N.R/models/download_update.dart';
import 'package:A.N.R/services/download_notifications.service.dart';
import 'package:A.N.R/utils/download.util.dart';
import 'package:A.N.R/utils/scan.util.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';

SendPort? notify() => IsolateNameServer.lookupPortByName(Ports.DOWNLOADED);

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      if (taskName == DownloadUtil.task) await _download();
    } catch (_) {}

    return Future.value(true);
  });
}

const List<String> _ignoreDownloadUrls = ['https://neoxxxxx.com/y9.jpg'];

Future<void> _download() async {
  while (true) {
    final chapter = await DownloadsDB.instance.chapterToDownload;
    if (chapter == null) break;

    final book = await DownloadsDB.instance.bookById(chapter.bookId);
    if (book == null) break;

    final notificationService = DownloadNotificationsService.instance;
    final notification = DownloadNotification(
      id: DownloadNotificationsService.generateId,
      book: book,
      chapter: chapter,
    );

    await notificationService.start(notification);

    final Scans scan = ScanUtil.byURL(chapter.url);
    final content = await scan.repository.content(chapter, 0);

    if (content.sources == null && content.text is String) {
      await DownloadsDB.instance.insertContent(ContentDownloaded(
        name: content.name,
        bookId: content.bookId,
        content: content.text!,
        chapterId: content.id,
      ));
    } else {
      Directory? storageDir = await getExternalStorageDirectory();
      storageDir = storageDir ?? await getTemporaryDirectory();

      final chapterDir = Directory(
        '${storageDir.path}/${book.id}/${chapter.id}',
      );

      if (!chapterDir.existsSync()) await chapterDir.create(recursive: true);

      final dio = Dio();
      final sources = (content.sources ?? [])
          .where((src) => !_ignoreDownloadUrls.contains(src))
          .toList();

      final downloadedImages = <String>[];
      final totalProgress = 100 * sources.length;

      int downloadIndex = 0;
      double progress = 0;

      await notificationService.remove(notification.id);

      for (String src in sources) {
        downloadIndex++;

        final fileType = src.split('.').last.trim();
        final saveDir = Directory(
          '${chapterDir.path}/$downloadIndex.$fileType',
        );

        if (src.contains('base64')) {
          try {
            final bytes = base64.decode(src);
            final file = File(saveDir.path);

            await file.writeAsBytes(bytes);
            downloadedImages.add(saveDir.path);
          } catch (_) {}

          continue;
        }

        try {
          await dio.download(
            src,
            saveDir.path,
            onReceiveProgress: (count, total) {
              if (total != -1) {
                final currentProgress = (count / total * 100) * downloadIndex;
                progress = progress + (currentProgress / totalProgress * 100);

                notificationService.progress(notification, progress.round());
              }
            },
          );

          downloadedImages.add(saveDir.path);
        } catch (_) {}
      }

      await DownloadsDB.instance.insertContent(ContentDownloaded(
        name: content.name,
        bookId: content.bookId,
        content: jsonEncode(downloadedImages),
        chapterId: content.id,
      ));
    }

    await notificationService.remove(notification.id);
    await notificationService.finished(notification);

    notify()?.send(DownloadUpdate(bookId: book.id, chapterId: chapter.id));
  }
}
