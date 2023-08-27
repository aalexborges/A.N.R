import 'package:anr/models/book_data.dart';
import 'package:anr/models/book_item.dart';
import 'package:anr/models/chapter.dart';
import 'package:anr/models/scan.dart';

class Reader {
  const Reader({required this.bookData, required this.chapterIndex});

  final BookData bookData;
  final int chapterIndex;

  Scan get scan => bookItem.scan;
  BookItem get bookItem => bookData.bookItem;
  List<Chapter> get chapters => bookData.chapters;
}
