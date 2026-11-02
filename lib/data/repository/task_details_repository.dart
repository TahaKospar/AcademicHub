import 'package:academichub/data/services/task_details_services.dart';
import 'package:academichub/data/model/task_details_model.dart';

class TaskDetailsRepository {
  final TaskDetailsServices _services = TaskDetailsServices();
  Future<TaskDetailsModel?> getUserTask({required String uid, required String dayId})  {
    return _services.fetchUserTask(uid: uid, dayId: dayId);
  }
}
