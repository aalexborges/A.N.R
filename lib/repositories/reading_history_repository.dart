import 'package:anr/models/book.dart';
import 'package:anr/models/chapter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ReadingHistoryRepository {
  const ReadingHistoryRepository._();

  static DatabaseReference? _baseRef;
  static const I = ReadingHistoryRepository._();

  Future<DatabaseReference> get baseRef async {
    if (_baseRef is DatabaseReference) return _baseRef!;

    _baseRef = await _initBaseRef();
    return _baseRef!;
  }

  Future<DatabaseReference> _initBaseRef() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user is User) {
      final ref = FirebaseDatabase.instance.ref('users/${user.uid}/reading_history');
      await ref.keepSynced(true);

      return ref;
    }

    throw Error();
  }

  Future<double> update(Chapter chapter, double value) async {
    if (chapter.readingProgress == value) return value;
    if (value < 1) return value;
    if (value < 0) throw Error();

    final ref = await baseRef;
    final progress = value >= 99 ? 100.0 : value;

    await ref.child(chapter.bookSlug).child(chapter.firebaseId).set(progress);
    chapter.setReadingProgress(value);

    return progress;
  }

  Future<double?> progress(Chapter chapter) async {
    final ref = await baseRef;
    final data = await ref.child(chapter.bookSlug).child(chapter.firebaseId).get();
    final progress = data.exists ? double.parse(data.value.toString()) : null;

    if (progress != null) chapter.setReadingProgress(progress);
    return progress;
  }

  Future<Stream<DatabaseEvent>> continueReading(Book book) async {
    final ref = await baseRef;
    return ref.child(book.slug).orderByKey().limitToLast(1).onValue;
  }
}
