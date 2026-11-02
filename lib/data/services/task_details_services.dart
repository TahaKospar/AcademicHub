import 'package:academichub/data/model/task_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskDetailsServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<TaskDetailsModel?> fetchUserTask({
    required String uid,
    required String dayId,
  }) async {
    final taskDoc = await _firestore
        .collection("tasks")
        .doc(uid)
        .collection("UserTasks")
        .doc(dayId)
        .get();

    final taskData = taskDoc.data();

    if (taskData == null) {
      return null;
    }
    return TaskDetailsModel.fromMap(taskData);
  }

  Future<void> getTaskType({required String dayId, required String uid}) async {
    final taskType = FirebaseFirestore.instance
        .collection("tasks")
        .doc(uid)
        .collection("UserTasks")
        .doc(dayId)
        .get();
  }
}
