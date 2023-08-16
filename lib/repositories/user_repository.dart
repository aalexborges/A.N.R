import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final User? _user = FirebaseAuth.instance.currentUser;

  String? get displayName => _user?.displayName;

  String? get email => _user?.email;

  String? get photoURL => _user?.photoURL;

  String? get uid => _user?.uid;

  String get uidOrReject {
    final value = uid;

    if (value is String && value.isNotEmpty) return value;
    throw Exception('User not found');
  }
}
