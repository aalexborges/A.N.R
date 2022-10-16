import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static Future<void> signIn() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'account-exists-with-different-credential') {
        throw 'Essa conta já existe com uma credencial diferente.';
      }

      if (error.code == 'invalid-credential') throw 'Credenciais invalidas.';

      throw 'Ocorreu um erro ao tentar entrar com o Google.';
    } catch (_) {
      throw 'Ocorreu um erro ao tentar entrar com o Google.';
    }
  }

  static Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();

    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }
}
