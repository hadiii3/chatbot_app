import 'package:chatbot_app/features/auth/data/models/student_model.dart';
import 'package:chatbot_app/features/dashboard/data/datasource/dashboard_local_datasource.dart';
import 'package:chatbot_app/features/dashboard/repositories/dashboard_repository.dart';

class DashboardRepoImpl implements DashboardRepository {
  final DashboardLocalDataSource _ds;
  DashboardRepoImpl(this._ds);

  @override
  StudentModel? getStudent() => _ds.getStudent();
}
