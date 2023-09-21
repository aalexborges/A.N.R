import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseRepository {
  DatabaseReference? _database;
  bool _initialized = false;

  bool get initialized => _initialized;
  DatabaseReference? get database => _database;

  Future<void> init({bool restart = false}) async {
    if (_initialized && !restart) return;

    _database = FirebaseDatabase.instance.ref('users/$_userUID');
    await _database!.keepSynced(true);

    _initialized = true;
  }

  Future<void> add(String node, Map<String, dynamic> data) async {
    await init();
    await _database!.child(node).set(data);
  }

  Future<DataSnapshot> get(String node) async {
    await init();
    return _database!.child(node).get();
  }

  Future<DatabaseEvent> once(String node) async {
    await init();
    return await _database!.child(node).once();
  }

  Future<void> update(String node, String key, Map<String, dynamic> data) async {
    await init();
    await _database!.child(node).child(key).update(data);
  }

  Future<void> delete(String node, String key) async {
    await init();
    await _database!.child(node).child(key).remove();
  }

  Future<DatabaseReference> child(String node) async {
    await init();
    return _database!.child(node);
  }

  String get _userUID {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid is String && uid.isNotEmpty) return uid;
    throw Exception('User not found');
  }
}
