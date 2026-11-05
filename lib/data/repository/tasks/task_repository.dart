import 'package:academichub/data/model/tassk/task_model.dart';
import 'package:academichub/data/services/tasks/task_services.dart';

class TaskRepository {
  final TaskServices _taskServices;
  TaskRepository(this._taskServices);
  Future<List<TaskModel>> getUserTasks({required String uid}) async {
    return _taskServices.fetchUserTasks(uid: uid);
  }
}
