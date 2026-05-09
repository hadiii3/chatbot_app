import 'package:dio/dio.dart';
import 'package:chatbot_app/core/network/api_client.dart';
import 'package:chatbot_app/core/errors/exceptions.dart';
import 'package:chatbot_app/features/vehicle/data/models/vehicle_permit.dart';

class VehicleRemoteDataSource {
  final ApiClient apiClient;

  VehicleRemoteDataSource(this.apiClient);

  Future<VehiclePermit?> getCurrentVehicleState() async {
    try {
      final response = await apiClient.get('/student/vehicle');
      if (response.statusCode == 200 && response.data['success'] == true) {
        if (response.data['status'] == 'none') {
          return null;
        }
        final map = response.data['data'] as Map<String, dynamic>;
        map['status'] = response.data['status']; // Inject status into map
        return VehiclePermit.fromMap(map);
      } else {
        throw AuthException(
            response.data['message'] ?? 'Failed to load vehicle state');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map) {
        throw AuthException(
            e.response?.data['message'] ?? 'Failed to load vehicle state');
      }
      throw const AuthException('Network error while loading vehicle state');
    }
  }

  Future<List<VehiclePermit>> getVehicleHistory() async {
    try {
      final response = await apiClient.get('/student/vehicle-requests/history');
      if (response.statusCode == 200 && response.data['success'] == true) {
        final list = response.data['data'] as List;
        return list
            .map((e) => VehiclePermit.fromMap(e as Map<String, dynamic>))
            .toList();
      } else {
        throw AuthException(
            response.data['message'] ?? 'Failed to load vehicle history');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map) {
        throw AuthException(
            e.response?.data['message'] ?? 'Failed to load vehicle history');
      }
      throw const AuthException('Network error while loading vehicle history');
    }
  }

  Future<VehiclePermit> requestVehiclePermit({
    required String vehicleType,
    required String vehicleModel,
    required String vehicleColor,
    required String plateNumber,
  }) async {
    try {
      final response = await apiClient.post(
        '/student/vehicle-requests',
        data: {
          'vehicle_type': vehicleType,
          'vehicle_model': vehicleModel,
          'vehicle_color': vehicleColor,
          'plate_number': plateNumber,
        },
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        // Response contains id and status, we mock the rest since we fetch history later
        return VehiclePermit(
          id: response.data['data']['id'] as int,
          status: PermitStatus.pending,
          licensePlate: plateNumber,
          make: vehicleType,
          model: vehicleModel,
          color: vehicleColor,
          requestedAt: DateTime.now(),
        );
      } else {
        throw AuthException(
            response.data['message'] ?? 'Failed to submit vehicle request');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        if (e.response?.data['message'] != null) {
          throw AuthException(e.response?.data['message']);
        }
      }
      if (e.response != null && e.response?.data is Map) {
        throw AuthException(
            e.response?.data['message'] ?? 'Failed to submit vehicle request');
      }
      throw const AuthException('Network error while submitting vehicle request');
    }
  }
}
