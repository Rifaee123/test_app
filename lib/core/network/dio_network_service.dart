import 'package:dio/dio.dart';
import 'package:test_app/core/network/network_service.dart';

class DioNetworkService implements NetworkService {
  final Dio _dio;

  DioNetworkService(this._dio);

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get(path, queryParameters: queryParameters);
    return response.data;
  }

  @override
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  @override
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  @override
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
    );
    return response.data;
  }
}
