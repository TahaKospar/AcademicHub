import 'package:academichub/data/services/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final AuthServices authServices;
  AuthRepository(this.authServices);

  Future<UserCredential> login({
    required String academicCode,
    required String password,
  }) async {
    return await authServices.loginWithEmail(
      academicCode: academicCode,
      password: password,
    );
  }

  Future<void> register({
    required String name,
    required String academicCode,
    required String password,
    required String confirmPassword,
  }) async {
    UserCredential userCredential = await authServices.registerWithEmail(
      academicCode: academicCode,
      password: password,
      confirmPassword: confirmPassword,
      name: name,
    );

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'name': name,
            'academicCode': academicCode,
            'uid': userCredential.user!.uid,
            'createdAt': DateTime.now(),
          });
    } catch (firestoreError) {
      await userCredential.user?.delete();
      throw Exception("Failed to Create Account ");
    }
  }
}