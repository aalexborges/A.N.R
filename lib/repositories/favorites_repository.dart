import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FavoritesRepository {
  FavoritesRepository._() {
    final user = FirebaseAuth.instance.currentUser;

    if (user is User) _ref = FirebaseDatabase.instance.ref('users/${user.uid}/favorites')..keepSynced(true);
  }

  static final instance = FavoritesRepository._();
  static late DatabaseReference _ref;

  get all async {
    final snapshot = await _ref.get();
  }
}
