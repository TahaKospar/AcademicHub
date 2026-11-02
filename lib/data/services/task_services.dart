import 'package:academichub/data/model/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<TaskModel>> fetchUserTasks({required String uid}) async {
    final userDoc = await _firestore.collection("tasks").doc(uid).get();

    final userData = userDoc.data();

    if (userData == null || userData['createdAt'] == null) {
      throw Exception("User createdAt not found");
    }

    final createdAtValue = userData['createdAt'];

    DateTime createdAt;

    if (createdAtValue is Timestamp) {
      createdAt = createdAtValue.toDate();
    } else if (createdAtValue is DateTime) {
      createdAt = createdAtValue;
    } else {
      throw Exception("Invalid createdAt format");
    }

    final startDate = DateTime(createdAt.year, createdAt.month, createdAt.day);

    final snapshot = await _firestore
        .collection("tasks")
        .doc(uid)
        .collection("UserTasks")
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      final dayNumber = int.tryParse(doc.id.replaceAll('day', ''));

      if (dayNumber == null || dayNumber < 1) {
        throw FormatException('Invalid task day ID: ${doc.id}');
      }

      final scheduledDate = calculateStudyDate(startDate, dayNumber);

      return TaskModel(
        audioUrl: _optionalString(data, "audioUrl", doc.id),
        dayId: doc.id,
        textContent: _requiredString(data, "textContent", doc.id),
        title: _requiredString(data, "title", doc.id),
        type: _requiredString(data, "type", doc.id),
        status: _requiredString(data, "status", doc.id),
        scheduledDate: scheduledDate,
      );
    }).toList();
  }

  String _requiredString(
    Map<String, dynamic> data,
    String field,
    String documentId,
  ) {
    final value = data[field];

    if (value is String) return value;

    throw FormatException(
      'Field "$field" is missing or invalid in task "$documentId".',
    );
  }

  String? _optionalString(
    Map<String, dynamic> data,
    String field,
    String documentId,
  ) {
    final value = data[field];

    if (value == null) return null;

    if (value is String) return value;

    throw FormatException(
      'Field "$field" must be a string when present in task "$documentId".',
    );
  }

  DateTime calculateStudyDate(DateTime startDate, int dayNumber) {
    DateTime currentDate = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );

    int currentDay = 1;

    while (currentDate.weekday == DateTime.friday) {
      currentDate = currentDate.add(const Duration(days: 1));
    }

    while (currentDay < dayNumber) {
      currentDate = currentDate.add(const Duration(days: 1));

      if (currentDate.weekday == DateTime.friday) {
        continue;
      }

      currentDay++;
    }

    return currentDate;
  }
}
