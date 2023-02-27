import 'package:anr/models/book.dart';
import 'package:anr/models/chapter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ReadingHistoryRepository {
  ReadingHistoryRepository._() {
    final user = FirebaseAuth.instance.currentUser;

    if (user is User) {
      _ref = FirebaseDatabase.instance.ref('users/${user.uid}/reading_history');
      _ref!.keepSynced(true);
    }
  }

  static final I = ReadingHistoryRepository._();
  static DatabaseReference? _ref;

  Future<ContinueReading?> continueReading(Book book) async {
    final ref = _ref;

    if (ref == null) return null;

    final data = await ref.child(book.slug).orderByKey().limitToLast(1).get();
    final item = data.children.first;
    final id = item.key;

    if (id == null) return null;

    return ContinueReading(
      id: Chapter.firebaseIdToId(id),
      progress: double.parse(item.value.toString()),
    );
  }

  Future<double?> progress(Chapter chapter) async {
    final ref = _ref;

    if (ref == null) return null;

    final data = await ref.child(chapter.bookSlug).child(chapter.firebaseId).get();

    if (!data.exists) return null;
    return double.parse(data.value.toString());
  }

  Widget? progressWidget(Chapter chapter) {
    final ref = _ref;

    if (ref == null) return null;

    return FutureBuilder(
      future: Future(() => progress(chapter)),
      builder: (context, snapshot) {
        if (snapshot.data == null || snapshot.hasError) return const SizedBox();

        return Container(
          width: 28,
          height: 28,
          margin: const EdgeInsets.only(left: 16),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  child: Icon(
                    Icons.remove_red_eye_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                ),
              ),
              Positioned.fill(
                child: CircularProgressIndicator(
                  value: snapshot.data! / 100,
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
