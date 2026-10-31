class TaskModel {
  final String? audioUrl;
  final String dayId;
  final String textContent;
  final String title;
  final String type;
  final String status;
  final DateTime scheduledDate;

  TaskModel({
    required this.audioUrl,
    required this.dayId,
    required this.textContent,
    required this.title,
    required this.type,
    required this.status,
    required this.scheduledDate,
  });
}