import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final User? _user = FirebaseAuth.instance.currentUser;

  String? get displayName => _user?.displayName;

  String? get email => _user?.email;

  String? get photoURL => _user?.photoURL;
}
