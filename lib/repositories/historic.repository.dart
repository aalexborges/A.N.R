import 'package:A.N.R/store/historic.store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobx/mobx.dart';

class HistoricRepository {
  HistoricRepository._() {
    final user = FirebaseAuth.instance.currentUser;

    if (user is User) {
      _ref = FirebaseDatabase.instance.ref('users/${user.uid}/historic');
      _ref!.keepSynced(true);
    }
  }

  static final instance = HistoricRepository._();

  static DatabaseReference? _ref;

  Future<HistoricMap> getAll() async {
    final ref = _ref;
    if (ref == null) throw Error();

    final snapshot = await ref.get();
    if (!snapshot.exists) return ObservableMap();

    final HistoricMap historic = ObservableMap();

    for (DataSnapshot data in snapshot.children) {
      final items = data.children;
      final chapters = ObservableMap<String, double>();

      for (DataSnapshot item in items) {
        final read = double.tryParse(item.value.toString()) ?? 0;
        chapters[item.key!.replaceAll('i__', '')] = read > 100 ? 100 : read;
      }

      historic[data.key!] = chapters;
    }

    return historic;
  }

  Future<void> upsert({
    required String bookId,
    required String chapterId,
    required double read,
  }) async {
    if (_ref == null) throw Error();

    final chapterRef = _ref!.child(bookId).child('i__$chapterId');
    await chapterRef.set(read);
  }
}
