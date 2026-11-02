part of 'task_details_cubit.dart';

@immutable
sealed class TaskDetailsState {}

final class TaskDetailsInitial extends TaskDetailsState {}

final class TaskDetailsLoading extends TaskDetailsState {}

final class TaskDetailsLoaded extends TaskDetailsState {
  final TaskDetailsModel task;
  TaskDetailsLoaded(this.task);
}

final class TaskDetailsError extends TaskDetailsState {
  final String errorMessage;
  TaskDetailsError(this.errorMessage);
}
