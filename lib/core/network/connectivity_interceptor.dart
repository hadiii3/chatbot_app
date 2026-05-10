import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    bool isConnected = false;
    // `connectivityResult` is a List<ConnectivityResult> in connectivity_plus 7.1.1
    isConnected = !connectivityResult.contains(ConnectivityResult.none);

    if (!isConnected) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'No internet connection available.',
          type: DioExceptionType.connectionError,
        ),
      );
    }
    return super.onRequest(options, handler);
  }
}
