import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  AuthRepository() {
    _google = GoogleSignIn();
  }

  late final GoogleSignIn _google;

  Future<void> signIn(BuildContext context) async {
    final googleUser = await _google.signIn();

    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }

  Future<void> signOut() async {
    await _google.signOut();
    await FirebaseAuth.instance.signOut();
  }
}
