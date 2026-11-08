import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();

    if (!doc.exists) {
      throw Exception('User profile not found');
    }

    return doc.data() ?? {};
  }

  Future<int> getUserTasksCount(String userId) async {
    final result = await _firestore
        .collection('tasks')
        .doc(userId)
        .collection('UserTasks')
        .where("status", isEqualTo: "Done")
        .count()
        .get();

    return result.count ?? 0;
  }

  Future<int> getActiveCourseCount(String userId) async {
    final result = await _firestore
        .collection('courses')
        .doc(userId)
        .collection('UserCourses')
        .where('isDone', isEqualTo: true)
        .count()
        .get();

    return result.count ?? 0;
  }
}
