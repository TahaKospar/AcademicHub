import 'package:academichub/data/repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  AuthCubit(this.authRepository) : super(AuthInitial());

  void login({required String academicCode, required String password}) async {
    emit(AuthLoadingState());
    String message;
    try {
      String fakeEmail = '$academicCode@academichub.com';
      await authRepository.login(academicCode: fakeEmail, password: password);
      emit(AuthSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email" || e.code == "invalid-credential") {
        message = "Error Data";
      } else {
        message = "Error ${e.code}";
      }
      emit(AuthErrorState(message));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  void register({
    required String name,
    required String password,
    required String confirmPassword,
    required String academicCode,
  }) async {
    emit(AuthLoadingState());
    String message;
    try {
      String fakeEmail = '$academicCode@academichub.com';
      await authRepository.register(
        academicCode: fakeEmail,
        name: name,
        password: password,
        confirmPassword: confirmPassword,
      );
      emit(AuthSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        message = "The Email is already in use Try another Email";
      } else if (e.code == "weak-password") {
        message = "Weak Password";
      } else {
        message = "${e.code}";
      }
      emit(AuthErrorState(message));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }
}
