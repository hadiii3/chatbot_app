import 'package:dartz/dartz.dart';
import 'package:chatbot_app/core/errors/exceptions.dart';
import 'package:chatbot_app/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:chatbot_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:chatbot_app/features/auth/data/models/student_model.dart';
import 'package:chatbot_app/features/auth/repositories/auth_repository.dart';

class AuthRepoImpl implements AuthRepository {
  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepoImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<Either<String, StudentModel>> login({
    required String studentId,
    required String password,
  }) async {
    try {
      final data = await _remoteDataSource.login(
          studentId: studentId, password: password);
      final token = data['token'] as String;
      final studentMap = data['student'] as Map<String, dynamic>;
      final student = StudentModel.fromMap(studentMap);

      await _localDataSource.cacheSession(token, student);
      return Right(student);
    } on AuthException catch (e) {
      return Left(e.message);
    } catch (e) {
      return const Left('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
    await _localDataSource.logout();
  }

  @override
  bool isLoggedIn() => _localDataSource.isLoggedIn();

  @override
  StudentModel? getCachedStudent() => _localDataSource.getCachedStudent();
}
