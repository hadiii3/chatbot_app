import 'package:dartz/dartz.dart';
import 'package:chatbot_app/features/auth/data/models/student_model.dart';
import 'package:chatbot_app/features/dashboard/data/datasource/dashboard_local_datasource.dart';
import 'package:chatbot_app/features/dashboard/data/datasource/dashboard_remote_datasource.dart';
import 'package:chatbot_app/features/dashboard/repositories/dashboard_repository.dart';

class DashboardRepoImpl implements DashboardRepository {
  final DashboardLocalDataSource _localDataSource;
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepoImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<Either<String, StudentModel>> getStudent() async {
    try {
      final student = await _remoteDataSource.getProfile();
      await _localDataSource.cacheStudent(student);
      return Right(student);
    } catch (e) {
      final cachedStudent = _localDataSource.getStudent();
      if (cachedStudent != null) {
        return Right(cachedStudent);
      }
      return Left('Failed to load profile: ${e.toString()}');
    }
  }
}
