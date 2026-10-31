import 'package:academichub/data/model/task_model.dart';
import 'package:academichub/data/repository/task_repository.dart';
import 'package:bloc/bloc.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final TaskRepository taskRepository;

  TasksCubit(this.taskRepository) : super(TasksInitial());
  Future<void> fetchUserTasks({required String uid}) async {
    emit(TasksLoadingState());
    try {
      final tasks = await taskRepository.getUserTasks(uid: uid);
      emit(TasksLoadedState(tasks));
    } catch (error) {
      emit(TasksErrorState(error.toString()));
    }
  }
}