import 'package:anr/models/book.dart';
import 'package:anr/models/scan.dart';

class BookRepository {
  const BookRepository();

  Future<List<Book>> search({required Scan scan, required String value}) async {
    return await scan.repository.search(value);
  }

  Future<Map<Scan, List<Book>>> get lastAdded async {
    final data = await Future.wait(Scan.values.map((scan) {
      return scan.repository.lastAdded();
    }));

    return Map.fromIterables(Scan.values, data);
  }
}
