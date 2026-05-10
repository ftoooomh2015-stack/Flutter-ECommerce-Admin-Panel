import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  /// 🔹 تسجيل الدخول بالبريد
  static Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user;
  }

  /// 🔹 تسجيل الدخول بجوجل (ويب)
  static Future<User?> signInWithGoogle() async {
    final GoogleAuthProvider provider = GoogleAuthProvider();
    provider.setCustomParameters({'prompt': 'select_account'});

    final credential = await _auth.signInWithPopup(provider);

    return credential.user;
  }

  /// 🔹 ربط حساب (اختياري)
  static Future<void> linkEmailPassword({
    required User user,
    required String email,
    required String password,
  }) async {
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    await user.linkWithCredential(credential);
  }
}