import 'package:cloud_firestore/cloud_firestore.dart';

class TaskDetailsModel {
  final String? audioUrl;
  final String textContent;
  final String title;
  final String type;
  final String status;

  final String? answerText;
  final String? answerAudioUrl;

  final DateTime? submittedAt;
  final DateTime? completedAt;

  const TaskDetailsModel({
    this.audioUrl,
    required this.textContent,
    required this.title,
    required this.type,
    required this.status,
    this.answerText,
    this.answerAudioUrl,
    this.submittedAt,
    this.completedAt,
  });

  factory TaskDetailsModel.fromMap(Map<String, dynamic> map) {
    return TaskDetailsModel(
      audioUrl: map['audioUrl'],
      textContent: map['textContent'],
      title: map['title'],
      type: map['type'],
      status: map['status'],
      answerText: map['answerText'],
      answerAudioUrl: map['answerAudioUrl'],
      submittedAt: (map['submittedAt'] as Timestamp?)?.toDate(),
      completedAt: (map['completedAt'] as Timestamp?)?.toDate(),
    );
  }
}
