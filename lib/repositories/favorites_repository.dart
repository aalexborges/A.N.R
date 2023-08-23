import 'package:anr/models/book_item.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/service_locator.dart';
import 'package:firebase_database/firebase_database.dart';

class FavoritesRepository {
  final _node = 'favorites';

  Future<BookItem?> getOne(String slug, {bool forceUpdate = false}) async {
    if (forceUpdate) {
      final item = await databaseRepository.get('$_node/$slug');
      return item.exists ? BookItem.fromMap(item.value as dynamic) : null;
    }

    final item = await databaseRepository.once('$_node/$slug');
    return item.snapshot.exists ? BookItem.fromMap(item.snapshot.value as dynamic) : null;
  }

  Future<List<BookItem>> get({Scan? scan, bool forceUpdate = false}) async {
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
      return Scan.isOldScan(item['scan']) ? null : BookItem.fromMap(item);
    });

    return favorites.whereType<BookItem>().toList();
  }

  Future<bool> isFavorite(String slug) async {
    final item = await databaseRepository.once('$_node/$slug');
    return item.snapshot.exists;
  }

  Future<bool> toggleFavorite(bool isFavorite, BookItem bookItem) async {
    try {
      if (isFavorite) {
        await databaseRepository.delete(_node, bookItem.slug);
      } else {
        await databaseRepository.add('$_node/${bookItem.slug}', bookItem.toMap());
      }

      return true;
    } catch (_) {
      return false;
    }
  }
}
