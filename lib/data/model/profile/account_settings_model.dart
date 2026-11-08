
class AccountSettingsModel {
  final String name;
  final String academicCode;

  AccountSettingsModel({
    required this.name,
    required this.academicCode,
  });
}

class NotificationPreferencesModel {
  final bool liveClassReminders;
  final bool taskFeedbackUpdates;
  final bool academyAnnouncements;

  const NotificationPreferencesModel({
    this.liveClassReminders = true,
    this.taskFeedbackUpdates = true,
    this.academyAnnouncements = false,
  });

  factory NotificationPreferencesModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return NotificationPreferencesModel(
      liveClassReminders: json['liveClassReminders'] ?? true,
      taskFeedbackUpdates: json['taskFeedbackUpdates'] ?? true,
      academyAnnouncements: json['academyAnnouncements'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'liveClassReminders': liveClassReminders,
      'taskFeedbackUpdates': taskFeedbackUpdates,
      'academyAnnouncements': academyAnnouncements,
    };
  }
}
