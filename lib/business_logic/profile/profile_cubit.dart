import 'package:academichub/data/model/profile/profile_model.dart';
import 'package:academichub/data/repository/profile_repository/profile_repository.dart';
import 'package:bloc/bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileCubit(this._profileRepository) : super(ProfileInitial());

  Future<void> fetchDashboardData(String userId) async {
    emit(ProfileLoading());

    try {
      final profileData = await _profileRepository.fetchDashboardData(userId);

      emit(ProfileLoaded(profileData));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
