part of 'auth_cubit.dart';

@immutable
class AuthState {}

final class AuthInitial extends AuthState {}

class AuthPageChangeState extends AuthState {
  final int pageIndex;
  AuthPageChangeState(this.pageIndex);
}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {}

class AuthErrorState extends AuthState {
  final errorMessage;
  AuthErrorState(this.errorMessage);
}
