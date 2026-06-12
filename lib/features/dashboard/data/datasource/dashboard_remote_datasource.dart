import 'package:dio/dio.dart';
import 'package:chatbot_app/core/network/api_client.dart';
import 'package:chatbot_app/core/errors/exceptions.dart';
import 'package:chatbot_app/features/auth/data/models/student_model.dart';

import 'package:chatbot_app/core/constants/app_constants.dart';

class DashboardRemoteDataSource {
  final ApiClient apiClient;

  DashboardRemoteDataSource(this.apiClient);

  Future<StudentModel> getProfile() async {
    try {
      final response = await apiClient.get(ApiEndpoints.profile);
      if (response.statusCode == 200 && response.data['success'] == true) {
        return StudentModel.fromMap(
            response.data['data'] as Map<String, dynamic>);
      } else {
        throw AuthException(
            response.data['message'] ?? 'Failed to load profile');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map) {
        throw AuthException(
            e.response?.data['message'] ?? 'Failed to load profile');
      }
      throw const AuthException('Network error while loading profile');
    }
  }
}
