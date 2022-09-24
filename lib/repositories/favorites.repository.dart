import 'dart:convert';

import 'package:A.N.R/models/book.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobx/mobx.dart';

class FavoritesRepository {
  FavoritesRepository._() {
    final user = FirebaseAuth.instance.currentUser;

    if (user is User) {
      _ref = FirebaseDatabase.instance.ref('users/${user.uid}/favorites');
      _ref!.keepSynced(true);
    }
  }

  static final instance = FavoritesRepository._();

  static DatabaseReference? _ref;

  Future<ObservableMap<String, Book>> getAll() async {
    final ref = _ref;
    if (ref == null) throw Error();

    final snapshot = await ref.get();
    if (!snapshot.exists) return ObservableMap();

    final favorites = ObservableMap<String, Book>();

    for (DataSnapshot data in snapshot.children) {
      final itemJSON = jsonEncode(data.value);
      final item = jsonDecode(itemJSON);

      favorites[data.key!] = Book.fromMap(item);
    }

    return favorites;
  }

  Future<void> addOne(Book book) async {
    final ref = _ref;
    if (ref == null) throw Error();

    await ref.child(book.id).set(book.toMap());
  }

  Future<void> removeOne(String id) async {
    final ref = _ref;
    if (ref == null) throw Error();

    await ref.child(id).remove();
  }
}
