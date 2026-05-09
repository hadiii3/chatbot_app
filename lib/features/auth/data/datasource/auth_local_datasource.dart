import 'package:hive_flutter/hive_flutter.dart';
import 'package:chatbot_app/core/constants/app_constants.dart';
import 'package:chatbot_app/core/errors/exceptions.dart';
import 'package:chatbot_app/features/auth/data/models/student_model.dart';

class AuthLocalDataSource {
  final Box<dynamic> _box;
  AuthLocalDataSource(this._box);

  Future<StudentModel> login({
    required String studentId,
    required String password,
  }) async {
    // Validate student ID format
    if (studentId.trim().isEmpty) {
      throw const AuthException('Student ID is required.');
    }
    if (password.isEmpty) {
      throw const AuthException('Password cannot be empty.');
    }

    // Mock authentication — look up student by ID
    final student = MockStudents.getById(studentId);
    if (student == null) {
      throw const AuthException('No student account found for this ID.');
    }

    // Persist session in Hive
    await _box.put(AppConstants.isLoggedInKey, true);
    await _box.put(AppConstants.studentDataKey, student.toMap());

    return student;
  }

  Future<void> logout() async {
    await _box.put(AppConstants.isLoggedInKey, false);
    await _box.delete(AppConstants.studentDataKey);
  }

  bool isLoggedIn() {
    return _box.get(AppConstants.isLoggedInKey, defaultValue: false) as bool;
  }

  StudentModel? getCachedStudent() {
    final raw = _box.get(AppConstants.studentDataKey);
    if (raw == null) return null;
    try {
      return StudentModel.fromMap(raw as Map<dynamic, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
