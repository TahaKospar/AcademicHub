part of 'profile_cubit.dart';

sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final ProfileModel profileModel;
  ProfileLoaded(this.profileModel);
}

final class ProfileError extends ProfileState {
  final String errorMessage;
  ProfileError(this.errorMessage);
}
