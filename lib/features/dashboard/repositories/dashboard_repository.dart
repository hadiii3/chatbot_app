import 'package:dartz/dartz.dart';
import 'package:chatbot_app/features/auth/data/models/student_model.dart';

abstract class DashboardRepository {
  Future<Either<String, StudentModel>> getStudent();
}
