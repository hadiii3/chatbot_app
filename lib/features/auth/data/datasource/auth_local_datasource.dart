import 'package:hive_flutter/hive_flutter.dart';
import 'package:chatbot_app/core/constants/app_constants.dart';
import 'package:chatbot_app/features/auth/data/models/student_model.dart';

class AuthLocalDataSource {
  final Box<dynamic> _box;
  AuthLocalDataSource(this._box);

  Future<void> cacheSession(String token, StudentModel student) async {
    await _box.put(AppConstants.authTokenKey, token);
    await _box.put(AppConstants.isLoggedInKey, true);
    await _box.put(AppConstants.studentDataKey, student.toMap());
  }

  Future<void> logout() async {
    await _box.delete(AppConstants.authTokenKey);
    await _box.put(AppConstants.isLoggedInKey, false);
    await _box.delete(AppConstants.studentDataKey);
  }

  bool isLoggedIn() {
    final token = _box.get(AppConstants.authTokenKey);
    final loggedIn =
        _box.get(AppConstants.isLoggedInKey, defaultValue: false) as bool;
    return token != null && loggedIn;
  }

  StudentModel? getCachedStudent() {
    final raw = _box.get(AppConstants.studentDataKey);
    if (raw == null) return null;
    try {
      final map = Map<String, dynamic>.from(raw as Map);
      return StudentModel.fromMap(map);
    } catch (_) {
      return null;
    }
  }
}
