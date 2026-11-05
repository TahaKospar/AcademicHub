import 'package:academichub/data/model/tassk/task_details_model.dart';


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
