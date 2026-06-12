// Core App Constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Galala Uni';
  static const String universityEmail = '@gu.edu.eg';

  // Environment / APIs
  static const String apiBaseUrl = 'https://api.galalabot.app/api/v1';
  static const String aiBaseUrl = 'https://ai.galalabot.app/api';

  // Hive Boxes
  static const String appSettingsBox = 'app_settings';
  static const String authBox = 'auth_box';

  // Hive Keys
  static const String authTokenKey = 'auth_token';
  static const String studentDataKey = 'student_data';
  static const String isLoggedInKey = 'is_logged_in';
}

class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/student/login';
  static const String logout = '/student/logout';

  // Dashboard
  static const String profile = '/student/profile';

  // Vehicle
  static const String vehicleCurrent = '/student/vehicle';
  static const String vehicleHistory = '/student/vehicle-requests/history';
  static const String vehicleRequest = '/student/vehicle-requests';
}

class AiEndpoints {
  AiEndpoints._();

  static const String chat = '/chat';
  static const String health = '/health';
}
