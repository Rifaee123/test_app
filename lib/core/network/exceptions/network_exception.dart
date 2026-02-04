/// Base class for all network-related exceptions
abstract class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const NetworkException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => message;
}

/// Thrown when there's a connection error (no internet, DNS failure, etc.)
class ConnectionException extends NetworkException {
  const ConnectionException({
    String message =
        'Unable to connect to the server. Please check your internet connection.',
    super.originalError,
  }) : super(message: message);
}

/// Thrown when the request times out
class TimeoutException extends NetworkException {
  const TimeoutException({
    String message = 'Request timed out. Please try again.',
    super.originalError,
  }) : super(message: message);
}

/// Thrown when the server returns an error response (4xx, 5xx)
class ServerException extends NetworkException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.originalError,
  });

  factory ServerException.fromStatusCode(
    int statusCode,
    String? serverMessage,
  ) {
    final message =
        serverMessage ?? _getDefaultMessageForStatusCode(statusCode);
    return ServerException(message: message, statusCode: statusCode);
  }

  static String _getDefaultMessageForStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please log in again.';
      case 403:
        return 'Access forbidden. You don\'t have permission to access this resource.';
      case 404:
        return 'Resource not found.';
      case 408:
        return 'Request timeout. Please try again.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Internal server error. Please try again later.';
      case 502:
        return 'Bad gateway. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return 'Server error (${statusCode}). Please try again.';
    }
  }
}

/// Thrown when the request is cancelled
class RequestCancelledException extends NetworkException {
  const RequestCancelledException({
    String message = 'Request was cancelled.',
    super.originalError,
  }) : super(message: message);
}

/// Thrown when an unknown network error occurs
class UnknownNetworkException extends NetworkException {
  const UnknownNetworkException({
    String message = 'An unexpected error occurred. Please try again.',
    super.originalError,
  }) : super(message: message);
}

/// Thrown when response parsing fails
class ParseException extends NetworkException {
  const ParseException({
    String message = 'Failed to parse server response.',
    super.originalError,
  }) : super(message: message);
}
