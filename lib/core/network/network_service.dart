import 'package:test_app/core/network/result.dart';

abstract class NetworkService {
  Future<Result<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  });
  Future<Result<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });
  Future<Result<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });
  Future<Result<dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });
}
