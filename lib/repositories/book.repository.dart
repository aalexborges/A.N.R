import 'package:A.N.R/constants/scans.dart';
import 'package:A.N.R/models/book.model.dart';
import 'package:A.N.R/models/book_data.model.dart';
import 'package:flutter/widgets.dart';

@immutable
class BookRepository {
  const BookRepository();

  static Future<Map<Scans, List<Book>>> getLatestBooksAdded() async {
    final data = await Future.wait(Scans.values.map((scan) {
      return scan.repository.lastAdded();
    }));

    return Map.fromIterables(Scans.values, data);
  }

  static Future<List<Book>> search(String value, Scans scan) async {
    try {
      return await scan.repository.search(value);
    } catch (_) {
      return [];
    }
  }

  static Future<BookData> data(Book book) async {
    return await book.scan.repository.data(book);
  }
}
