
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountSettingServices {
  AccountSettingServices();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();

    if (!doc.exists) {
      throw Exception('User profile not found');
    }

    return doc.data() ?? {};
  }

  Future<Map<String, dynamic>> getNotificationPreferences(
    String userId,
  ) async {
    final doc = await _firestore.collection('users').doc(userId).get();

    if (!doc.exists) {
      throw Exception('User profile not found');
    }
    final data = doc.data() ?? {};
    
    return Map<String, dynamic>.from(
      data['notificationPreferences'] ?? {
        'liveClassReminders': true,
        'taskFeedbackUpdates': true,
        'academyAnnouncements': false,
      },
    );
  }

  // Update notification preferences
  Future<void> updateNotificationPreferences(
    String userId,
    Map<String, dynamic> preferences,
  ) async {
    await _firestore.collection('users').doc(userId).update({
      'notificationPreferences': preferences,
    });
  }
}
