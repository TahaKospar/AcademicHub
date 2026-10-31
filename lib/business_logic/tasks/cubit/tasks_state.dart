part of 'tasks_cubit.dart';

sealed class TasksState {}

final class TasksInitial extends TasksState {}

final class TasksLoadingState extends TasksState {}

final class TasksLoadedState extends TasksState {
  final List<TaskModel> tasks;

  TasksLoadedState(this.tasks);
}

final class TasksErrorState extends TasksState {
  final String errorMessage;

  TasksErrorState(this.errorMessage);
}