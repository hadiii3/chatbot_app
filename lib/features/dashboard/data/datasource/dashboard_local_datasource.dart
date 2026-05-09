import 'package:hive_flutter/hive_flutter.dart';
import 'package:chatbot_app/core/constants/app_constants.dart';
import 'package:chatbot_app/features/auth/data/models/student_model.dart';

class DashboardLocalDataSource {
  final Box<dynamic> _box;
  DashboardLocalDataSource(this._box);

  StudentModel? getStudent() {
    final raw = _box.get(AppConstants.studentDataKey);
    if (raw == null) return null;
    return StudentModel.fromMap(raw as Map<dynamic, dynamic>);
  }
}
