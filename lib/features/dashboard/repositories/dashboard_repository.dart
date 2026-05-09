import 'package:chatbot_app/features/auth/data/models/student_model.dart';

abstract class DashboardRepository {
  StudentModel? getStudent();
}
