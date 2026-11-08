import 'package:academichub/data/model/profile/account_settings_model.dart';
import 'package:academichub/data/services/profile/account_setting_services.dart';

class AccountSettingsRepository {
  final AccountSettingServices _services;

  AccountSettingsRepository({AccountSettingServices? services})
    : _services = services ?? AccountSettingServices();

  Future<AccountSettingsModel> fetchAccountSettings(String userId) async {
    final data = await _services.getUserProfile(userId);

    return AccountSettingsModel(
      name: data['name'] ?? '',
      academicCode: data['academicCode'] ?? '',
    );
  }

  Future<NotificationPreferencesModel> fetchNotificationPreferences(
    String userId,
  ) async {
    final data = await _services.getNotificationPreferences(userId);

    return NotificationPreferencesModel.fromJson(data);
  }

  Future<void> updateNotificationPreferences(
    String userId,
    NotificationPreferencesModel preferences,
  ) async {
    await _services.updateNotificationPreferences(userId, preferences.toJson());
  }
}
