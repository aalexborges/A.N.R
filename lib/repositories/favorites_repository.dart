import 'package:anr/models/book.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FavoritesRepository {
  FavoritesRepository._() {
    final user = FirebaseAuth.instance.currentUser;

    if (user is User) {
      _ref = FirebaseDatabase.instance.ref('users/${user.uid}/favorites');
      _ref!.keepSynced(true);
    }
  }

  static final I = FavoritesRepository._();
  static DatabaseReference? _ref;

  Future<bool> isFavorite(String slug) async {
    final ref = _ref;

    if (ref == null) return false;

    final data = await ref.child(slug).get();
    return data.exists;
  }

  Future<void> setFavorite({required Book book, bool? remove}) async {
    final ref = _ref;

    if (ref == null) throw Error();

    if (remove == true) return await ref.child(book.slug).remove();
    await ref.child(book.slug).set(book.toMap());
  }
}
