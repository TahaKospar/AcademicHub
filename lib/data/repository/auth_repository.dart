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

  Future<UserCredential> register({
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
      await addUserLevelData(uid: userCredential.user!.uid, level: "Level4");
    } catch (error) {
      await userCredential.user?.delete();
      throw Exception("Failed to create account data: $error");
    }
    return userCredential;
  }
}

Future<void> addUserLevelData({
  required String uid,
  required String level,
}) async {
  final firestore = FirebaseFirestore.instance;
  final daysSnapshot = await firestore
      .collection('Levelid')
      .doc(level)
      .collection('Days')
      .get();

  final userTasksDocument = firestore.collection('tasks').doc(uid);
  await userTasksDocument.set({
    'uid': uid,
    'level': level,
    'createdAt': FieldValue.serverTimestamp(),
  });

  for (final day in daysSnapshot.docs) {
    await userTasksDocument.collection('UserTasks').doc(day.id).set({
      ...day.data(),
      'dayId': day.id,
      'status': 'Pending',
    });
  }
}
