part of 'tasks_cubit.dart';

@immutable
sealed class TasksState {}

final class TasksInitial extends TasksState {}

final class TasksLoadingState extends TasksState {}

final class TasksSuccessState extends TasksState {}

final class TasksErrorState extends TasksState {
  final errorMessage;
  TasksErrorState(this.errorMessage);
}
