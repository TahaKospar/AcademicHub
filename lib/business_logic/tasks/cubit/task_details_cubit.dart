import 'package:academichub/data/model/task_details_model.dart';
import 'package:academichub/data/repository/task_details_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'task_details_state.dart';

class TaskDetailsCubit extends Cubit<TaskDetailsState> {
  final TaskDetailsRepository _taskDetailsRepository;
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
