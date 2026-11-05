import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class HomePageServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();

    return doc.data() ?? <String, dynamic>{};
  }

Future<List<Map<String, dynamic>>> getUserTasks(String userId) async {
    final snapshot = await _firestore
        .collection('tasks')
        .doc(userId)
        .collection('UserTasks')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

    Future<Map<String, dynamic>?> getActiveCourse(String userId) async {
    final snapshot = await _firestore
        .collection('courses')
        .doc(userId)
        .collection('UserCourses')
        .where('isActive', isEqualTo: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    }

    return null;
  }
}
