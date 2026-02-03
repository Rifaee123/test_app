import 'package:dio/dio.dart';

/// Interceptor for logging HTTP requests and responses
/// Useful for debugging and monitoring network activity
class LoggingInterceptor extends Interceptor {
  final bool logRequest;
  final bool logResponse;
  final bool logError;

  LoggingInterceptor({
    this.logRequest = true,
    this.logResponse = true,
    this.logError = true,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (logRequest) {
      print('┌─────────────────────────────────────────────────────────');
      print('│ REQUEST');
      print('├─────────────────────────────────────────────────────────');
      print('│ Method: ${options.method}');
      print('│ URL: ${options.uri}');
      if (options.headers.isNotEmpty) {
        print('│ Headers:');
        options.headers.forEach((key, value) {
          // Don't log sensitive headers
          if (key.toLowerCase() == 'authorization') {
            print('│   $key: ***');
          } else {
            print('│   $key: $value');
          }
        });
      }
      if (options.queryParameters.isNotEmpty) {
        print('│ Query Parameters: ${options.queryParameters}');
      }
      if (options.data != null) {
        print('│ Body: ${options.data}');
      }
      print('└─────────────────────────────────────────────────────────');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (logResponse) {
      print('┌─────────────────────────────────────────────────────────');
      print('│ RESPONSE');
      print('├─────────────────────────────────────────────────────────');
      print('│ Status Code: ${response.statusCode}');
      print('│ URL: ${response.requestOptions.uri}');
      if (response.headers.map.isNotEmpty) {
        print('│ Headers:');
        response.headers.map.forEach((key, value) {
          print('│   $key: $value');
        });
      }
      print('│ Data: ${response.data}');
      print('└─────────────────────────────────────────────────────────');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (logError) {
      print('┌─────────────────────────────────────────────────────────');
      print('│ ERROR');
      print('├─────────────────────────────────────────────────────────');
      print('│ Type: ${err.type}');
      print('│ Message: ${err.message}');
      print('│ URL: ${err.requestOptions.uri}');
      if (err.response != null) {
        print('│ Status Code: ${err.response?.statusCode}');
        print('│ Response Data: ${err.response?.data}');
      }
      print('└─────────────────────────────────────────────────────────');
    }
    super.onError(err, handler);
  }
}
