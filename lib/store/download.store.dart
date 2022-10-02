import 'package:A.N.R/database/downloads_db.dart';
import 'package:A.N.R/models/book.model.dart';
import 'package:A.N.R/models/book_data.model.dart';
import 'package:A.N.R/models/book_download.model.dart';
import 'package:A.N.R/models/chapter.model.dart';
import 'package:A.N.R/utils/download.util.dart';
import 'package:mobx/mobx.dart';

part 'download.store.g.dart';

class DownloadStore = _DownloadStore with _$DownloadStore;

abstract class _DownloadStore with Store {
  @observable
  ObservableMap<String, bool> chapters = ObservableMap();

  @action
  Future<void> populate(String bookId) async {
    final items = await DownloadsDB.instance.chaptersByBookId(bookId);
    final chaptersId = <String, bool>{};

    for (Chapter item in items) {
      chaptersId[item.id] = item.finished;
    }

    chapters = ObservableMap.of(chaptersId);
  }

  @action
  void addFinishedChapter(String chapterId) {
    chapters.update(chapterId, (value) => true, ifAbsent: () => true);
  }

  @action
  Future<void> addInQueue(BookDownload book, Chapter chapter) async {
    await DownloadsDB.instance.upsertBook(book);
    await DownloadsDB.instance.insertChapter(chapter);
    chapters[chapter.id] = false;

    DownloadUtil.start();
  }

  Future<void> addMany({required Book book, required BookData bookData}) async {
    final downloadBook = BookDownload(
      scan: book.scan,
      url: book.url,
      name: book.name,
      type: bookData.type ?? book.type,
      sinopse: bookData.sinopse,
      imageURL: book.imageURL,
      imageURL2: book.imageURL2,
      categories: bookData.categories,
    );

    await DownloadsDB.instance.upsertBook(downloadBook);
    final newChapters = <String, bool>{};

    for (Chapter chapter in bookData.chapters.reversed) {
      if (chapters.containsKey(chapter.id)) continue;

      try {
        await DownloadsDB.instance.insertChapter(chapter);
        newChapters[chapter.id] = false;
      } catch (_) {}
    }

    chapters.addAll(newChapters);
    DownloadUtil.start();
  }

  @action
  Future<void> remove(Chapter chapter) async {
    await DownloadsDB.instance.deleteChapter(chapter);
    chapters.remove(chapter.id);
  }

  @action
  void dispose() {
    chapters = ObservableMap();
  }
}
