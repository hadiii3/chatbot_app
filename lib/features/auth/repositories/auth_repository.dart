import 'package:dartz/dartz.dart';
import 'package:chatbot_app/features/auth/data/models/student_model.dart';

abstract class AuthRepository {
  Future<Either<String, StudentModel>> login({
    required String studentId,
    required String password,
  });
  Future<void> logout();
  bool isLoggedIn();
  StudentModel? getCachedStudent();
}
