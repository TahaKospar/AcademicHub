import 'package:academichub/business_logic/tasks/task_details_state.dart';
import 'package:academichub/data/repository/tasks/task_details_repository.dart';
import 'package:bloc/bloc.dart';


class TaskDetailsCubit extends Cubit<TaskDetailsState> {
  TaskDetailsRepository _taskDetailsRepository;
  TaskDetailsCubit(this._taskDetailsRepository) : super(TaskDetailsInitial());
  Future<void> fetchUserTask({
    required String uid,
    required String dayId,
  }) async {
    emit(TaskDetailsLoading());
    try {
      final task = await _taskDetailsRepository.getUserTask(
        uid: uid,
        dayId: dayId,
      );
      if (task == null) {
        emit(TaskDetailsError("Task not found"));
        return;
      }
      emit(TaskDetailsLoaded(task));
    } catch (e) {
      emit(TaskDetailsError(e.toString()));
    }
  }

}
