import 'package:dartz/dartz.dart';
import 'package:chatbot_app/core/errors/exceptions.dart';
import 'package:chatbot_app/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:chatbot_app/features/auth/data/models/student_model.dart';
import 'package:chatbot_app/features/auth/repositories/auth_repository.dart';

class AuthRepoImpl implements AuthRepository {
  final AuthLocalDataSource _dataSource;
  AuthRepoImpl(this._dataSource);

  @override
  Future<Either<String, StudentModel>> login({
    required String studentId,
    required String password,
  }) async {
    try {
      final student =
          await _dataSource.login(studentId: studentId, password: password);
      return Right(student);
    } on AuthException catch (e) {
      return Left(e.message);
    } catch (e) {
      return const Left('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<void> logout() => _dataSource.logout();

  @override
  bool isLoggedIn() => _dataSource.isLoggedIn();

  @override
  StudentModel? getCachedStudent() => _dataSource.getCachedStudent();
}
