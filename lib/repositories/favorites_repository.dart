import 'package:anr/models/book.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/service_locator.dart';
import 'package:firebase_database/firebase_database.dart';

class FavoritesRepository {
  final _node = 'favorites';

  Future<Book?> getOne(String slug, {bool forceUpdate = false}) async {
    if (forceUpdate) {
      final item = await databaseRepository.get('$_node/$slug');
      return item.exists ? Book.fromMap(item.value as dynamic) : null;
    }

    final item = await databaseRepository.once('$_node/$slug');
    return item.snapshot.exists ? Book.fromMap(item.snapshot.value as dynamic) : null;
  }

  Future<List<Book>> get({Scan? scan, bool forceUpdate = false}) async {
    final ref = await databaseRepository.child(_node);
    final Query? query = scan is Scan ? ref.orderByChild('scan').equalTo(scan.value.toLowerCase()) : null;

    Iterable<DataSnapshot> items = const Iterable.empty();

    if (forceUpdate) {
      final result = await (query is Query ? query.get() : ref.get());
      items = result.children;
    } else {
      final result = await (query is Query ? query.once() : ref.once());
      items = result.snapshot.children;
    }

    final favorites = items.where((e) => e.exists).map((e) {
      final item = Map<String, dynamic>.from(e.value as dynamic);
      return Scan.isOldScan(item['scan']) ? null : Book.fromMap(item);
    });

    return favorites.whereType<Book>().toList();
  }

  Future<bool> isFavorite(String slug) async {
    final item = await databaseRepository.once('$_node/$slug');
    return item.snapshot.exists;
  }

  Future<bool> toggleFavorite(bool isFavorite, Book book) async {
    try {
      if (isFavorite) {
        await databaseRepository.delete(_node, book.slug);
      } else {
        await databaseRepository.add('$_node/${book.slug}', book.toMap());
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
