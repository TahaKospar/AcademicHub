import 'package:academichub/data/model/profile/account_settings_model.dart';
import 'package:academichub/data/repository/profile_repository/account_setting_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'account_settings_state.dart';

class AccountSettingsCubit extends Cubit<AccountSettingsState> {
  final AccountSettingsRepository _accountSettingsRepository;
  AccountSettingsCubit(this._accountSettingsRepository)
    : super(AccountSettingsInitial());

  Future<void> fetchAccountSettings(String userId) async {
    emit(AccountSettingsLoading());

    try {
      final profileData = await _accountSettingsRepository.fetchAccountSettings(
        userId,
      );
      emit(AccountSettingsLoaded(profileData));
    } catch (e) {
      emit(AccountSettingsError(e.toString()));
    }
  }
}
