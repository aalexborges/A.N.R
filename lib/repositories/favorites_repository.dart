import 'package:anr/models/book.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FavoritesRepository {
  const FavoritesRepository._();

  static DatabaseReference? _baseRef;
  static const I = FavoritesRepository._();

  Future<DatabaseReference> get baseRef async {
    if (_baseRef is DatabaseReference) return _baseRef!;

    _baseRef = await _initBaseRef();
    return _baseRef!;
  }

  Future<DatabaseReference> _initBaseRef() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user is User) {
      final ref = FirebaseDatabase.instance.ref('users/${user.uid}/favorites');
      await ref.keepSynced(true);

      return ref;
    }

    throw Error();
  }

  Future<bool> isFavorite(String slug) async {
    final ref = await baseRef;
    final data = await ref.child(slug).get();

    return data.exists;
  }

  Future<void> setFavorite({required Book book, bool? remove}) async {
    final ref = await baseRef;

    if (remove == true) return await ref.child(book.slug).remove();
    await ref.child(book.slug).set(book.toMap());
  }
}
