import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatbot_app/features/auth/cubit/auth_state.dart';
import 'package:chatbot_app/features/auth/repositories/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial()) {
    _checkSession();
  }

  void _checkSession() {
    if (_authRepository.isLoggedIn()) {
      final student = _authRepository.getCachedStudent();
      if (student != null) {
        emit(AuthAuthenticated(
            firstName: student.firstName, email: student.email));
      } else {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login(
      {required String studentId, required String password}) async {
    emit(AuthLoading());
    final result =
        await _authRepository.login(studentId: studentId, password: password);
    result.fold(
      (error) => emit(AuthError(error)),
      (student) => emit(AuthAuthenticated(
          firstName: student.firstName, email: student.email)),
    );
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(AuthUnauthenticated());
  }
}
