part of 'account_settings_cubit.dart';

@immutable
sealed class AccountSettingsState {}

final class AccountSettingsInitial extends AccountSettingsState {}

final class AccountSettingsLoading extends AccountSettingsState {}

final class AccountSettingsLoaded extends AccountSettingsState {
  final AccountSettingsModel settingsData;
  AccountSettingsLoaded(this.settingsData);
}

  final class AccountSettingsError extends AccountSettingsState {
    
    final String errorMessage;
  
  AccountSettingsError(this.errorMessage);
}
