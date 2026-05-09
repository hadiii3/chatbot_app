import 'package:hive_flutter/hive_flutter.dart';
import 'package:chatbot_app/core/constants/app_constants.dart';
import 'package:chatbot_app/features/auth/data/models/student_model.dart';

class DashboardLocalDataSource {
  final Box<dynamic> _box;
  DashboardLocalDataSource(this._box);

  StudentModel? getStudent() {
    final raw = _box.get(AppConstants.studentDataKey);
    if (raw == null) return null;
    try {
      return StudentModel.fromMap(Map<String, dynamic>.from(raw as Map));
    } catch (_) {
      return null;
    }
  }

  Future<void> cacheStudent(StudentModel student) async {
    await _box.put(AppConstants.studentDataKey, student.toMap());
  }
}
