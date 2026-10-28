import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  Future<UserCredential> loginWithEmail({
    required String academicCode,
    required String password,
  }) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: academicCode,
      password: password,
    );
  }
  Future<UserCredential> registerWithEmail({
    required String name,
    required String academicCode,
    required String password,
    required String confirmPassword
  }) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: academicCode,
      password: password,
    );
  }
}


