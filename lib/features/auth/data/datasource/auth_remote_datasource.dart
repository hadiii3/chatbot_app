import 'package:dio/dio.dart';
import 'package:chatbot_app/core/network/api_client.dart';
import 'package:chatbot_app/core/errors/exceptions.dart';
import 'package:chatbot_app/core/constants/app_constants.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  Future<Map<String, dynamic>> login({
    required String studentId,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.login,
        data: {
          'student_id': studentId,
          'password': password,
        },
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw AuthException(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map) {
        throw AuthException(e.response?.data['message'] ?? 'Login failed');
      }
      throw const AuthException('Network error during login');
    }
  }

  Future<void> logout() async {
    try {
      await apiClient.post(ApiEndpoints.logout);
    } catch (_) {
      // Ignore errors on logout
    }
  }
}
