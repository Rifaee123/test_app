import 'package:dio/dio.dart';
import 'package:test_app/core/network/exceptions/network_exception.dart';
import 'package:test_app/core/network/network_service.dart';
import 'package:test_app/core/network/result.dart';

class DioNetworkService implements NetworkService {
  final Dio _dio;

  DioNetworkService(this._dio);

  @override
  Future<Result<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return Result.success(response.data);
    } on DioException catch (e) {
      return Result.failure(_handleDioException(e));
    } catch (e) {
      return Result.failure(
        UnknownNetworkException(
          message: 'An unexpected error occurred: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Result<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return Result.success(response.data);
    } on DioException catch (e) {
      return Result.failure(_handleDioException(e));
    } catch (e) {
      return Result.failure(
        UnknownNetworkException(
          message: 'An unexpected error occurred: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Result<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return Result.success(response.data);
    } on DioException catch (e) {
      return Result.failure(_handleDioException(e));
    } catch (e) {
      return Result.failure(
        UnknownNetworkException(
          message: 'An unexpected error occurred: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Result<dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return Result.success(response.data);
    } on DioException catch (e) {
      return Result.failure(_handleDioException(e));
    } catch (e) {
      return Result.failure(
        UnknownNetworkException(
          message: 'An unexpected error occurred: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  /// Maps DioException to custom NetworkException
  NetworkException _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(originalError: error);

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final serverMessage = _extractServerMessage(error.response);

        if (statusCode != null) {
          return ServerException.fromStatusCode(statusCode, serverMessage);
        }
        return ServerException(
          message: serverMessage ?? 'Server error occurred.',
          originalError: error,
        );

      case DioExceptionType.connectionError:
        return ConnectionException(originalError: error);

      case DioExceptionType.cancel:
        return RequestCancelledException(originalError: error);

      case DioExceptionType.badCertificate:
        return ConnectionException(
          message:
              'Security certificate error. Unable to establish secure connection.',
          originalError: error,
        );

      case DioExceptionType.unknown:
        // Check if it's a network connectivity issue
        if (error.message?.contains('SocketException') ?? false) {
          return ConnectionException(originalError: error);
        }
        return UnknownNetworkException(
          message: error.message ?? 'An unexpected error occurred.',
          originalError: error,
        );
    }
  }

  /// Attempts to extract a meaningful error message from the server response
  String? _extractServerMessage(Response? response) {
    if (response?.data == null) return null;

    try {
      final data = response!.data;

      // Common API error message patterns
      if (data is Map<String, dynamic>) {
        // Try common error message keys
        return data['message'] as String? ??
            data['error'] as String? ??
            data['errorMessage'] as String? ??
            data['msg'] as String?;
      }

      // If response is a string
      if (data is String) {
        return data;
      }
    } catch (_) {
      // If parsing fails, return null
    }

    return null;
  }
}
