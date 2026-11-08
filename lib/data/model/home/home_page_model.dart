class CourseModel {
  final String title;
  final String instructor;
  final String schedule;
  final double progress;
  final String details;

  CourseModel({
    required this.title,
    required this.instructor,
    required this.schedule,
    required this.progress,
    required this.details,
  });
}

class TaskSummaryModel {
  final String id;
  final String title;
  final String type;
  final String time;
  final bool isCompleted;

  TaskSummaryModel({
    required this.id,
    required this.title,
    required this.type,
    required this.time,
    required this.isCompleted,
  });
}

class HomePageModel {
  final String userName;
  final String userInitial;
  final double overallProgress;
  final Map<String, double> sectionProgress;
  final CourseModel? activeCourse;
  final List<TaskSummaryModel> todoTasks;

  HomePageModel({
    required this.userName,
    required this.userInitial,
    required this.overallProgress,
    required this.sectionProgress,
    this.activeCourse,
    required this.todoTasks,
  });
}
