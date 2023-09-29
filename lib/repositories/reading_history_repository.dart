import 'package:anr/models/book.dart';
import 'package:anr/models/chapter.dart';
import 'package:anr/service_locator.dart';
import 'package:firebase_database/firebase_database.dart';

class ReadingHistoryRepository {
  final _node = 'reading_history';

  Future<double> progress(String slug, String firebaseId) async {
    final event = await databaseRepository.once('$_node/$slug/$firebaseId/progress');
    final snapshot = event.snapshot;

    if (snapshot.exists) return double.tryParse(snapshot.value.toString()) ?? 0;
    return 0;
  }

  Future<void> update({required Book book, required Chapter chapter, required double progress}) async {
    final child = await databaseRepository.child('$_node/${book.slug}');

    final lastReadItems = await child.orderByChild('createdAt').limitToLast(1).get();
    final item = await databaseRepository.get('$_node/${book.slug}/${chapter.firebaseId}');

    if (item.exists) {
      await item.ref.update({'progress': progress});
    } else {
      await item.ref.set({'progress': progress, 'createdAt': DateTime.now().millisecondsSinceEpoch});
    }

    if (lastReadItems.exists) {
      final lastRead = lastReadItems.children.first;
      final id = Chapter.idByFirebaseId(lastRead.key!);

      if (id > chapter.id) await lastRead.ref.update({'createdAt': DateTime.now().millisecondsSinceEpoch});
    }
  }

  Future<Stream<DatabaseEvent>> continueReading(String slug) async {
    final child = await databaseRepository.child('$_node/$slug');
    return child.orderByChild('createdAt').limitToLast(1).onValue;
  }

  Stream<DatabaseEvent> chapterProgressStream(String slug, String firebaseId) {
    return FirebaseDatabase.instance.ref('users/${databaseRepository.userUID}/$_node/$slug/$firebaseId').onValue;
  }
}
