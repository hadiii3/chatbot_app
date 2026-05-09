import 'dart:collection';
import 'package:dio/dio.dart';

class RateLimitInterceptor extends Interceptor {
  final int maxRequests;
  final Duration window;
  final Queue<DateTime> _requestTimestamps = Queue<DateTime>();

  RateLimitInterceptor({
    this.maxRequests = 5,
    this.window = const Duration(seconds: 5),
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final now = DateTime.now();

    // Clean up old timestamps
    while (_requestTimestamps.isNotEmpty &&
        now.difference(_requestTimestamps.first) > window) {
      _requestTimestamps.removeFirst();
    }

    if (_requestTimestamps.length >= maxRequests) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'Too many requests. Please try again later.',
          type: DioExceptionType.cancel,
        ),
      );
    }

    _requestTimestamps.addLast(now);
    return super.onRequest(options, handler);
  }
}
