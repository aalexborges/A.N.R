import 'package:A.N.R/models/book_download.model.dart';
import 'package:A.N.R/models/chapter.model.dart';

class DownloadNotification {
  final int id;
  final BookDownload book;
  final Chapter chapter;

  const DownloadNotification({
    required this.id,
    required this.book,
    required this.chapter,
  });
}
