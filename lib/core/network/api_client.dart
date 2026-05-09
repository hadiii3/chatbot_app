import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:chatbot_app/core/constants/app_constants.dart';
import 'package:chatbot_app/core/network/connectivity_interceptor.dart';
import 'package:chatbot_app/core/network/rate_limit_interceptor.dart';

class ApiClient {
  final Dio dio;
  final Box<dynamic> authBox;

  ApiClient({required this.dio, required this.authBox}) {
    dio.options.baseUrl = 'https://api.eightyeightevents.me/api/v1';
    dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);

    dio.interceptors.add(ConnectivityInterceptor());
    dio.interceptors.add(RateLimitInterceptor(
        maxRequests: 5, window: const Duration(seconds: 5)));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = authBox.get(AppConstants.authTokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    return dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return dio.post(path, data: data);
  }
}
