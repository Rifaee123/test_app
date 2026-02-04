import 'package:test_app/core/network/exceptions/network_exception.dart';

/// A Result type that represents either a success or a failure.
/// This is similar to Either<Failure, Success> pattern but more specific to our use case.
sealed class Result<T> {
  const Result();

  /// Creates a successful result with data
  const factory Result.success(T data) = Success<T>;

  /// Creates a failed result with an exception
  const factory Result.failure(NetworkException exception) = Failure<T>;

  /// Returns true if this is a Success
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a Failure
  bool get isFailure => this is Failure<T>;

  /// Executes [onSuccess] if this is a Success, otherwise executes [onFailure]
  R when<R>({
    required R Function(T data) onSuccess,
    required R Function(NetworkException exception) onFailure,
  }) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).data);
    } else {
      return onFailure((this as Failure<T>).exception);
    }
  }

  /// Executes [onSuccess] if this is a Success, otherwise does nothing
  void whenSuccess(void Function(T data) onSuccess) {
    if (this is Success<T>) {
      onSuccess((this as Success<T>).data);
    }
  }

  /// Executes [onFailure] if this is a Failure, otherwise does nothing
  void whenFailure(void Function(NetworkException exception) onFailure) {
    if (this is Failure<T>) {
      onFailure((this as Failure<T>).exception);
    }
  }

  /// Maps the success value to a new type
  Result<R> map<R>(R Function(T data) mapper) {
    return when(
      onSuccess: (data) => Result.success(mapper(data)),
      onFailure: (exception) => Result.failure(exception),
    );
  }

  /// Maps the success value to a new Result
  Result<R> flatMap<R>(Result<R> Function(T data) mapper) {
    return when(
      onSuccess: (data) => mapper(data),
      onFailure: (exception) => Result.failure(exception),
    );
  }

  /// Returns the data if Success, otherwise returns the provided default value
  T getOrElse(T defaultValue) {
    return when(onSuccess: (data) => data, onFailure: (_) => defaultValue);
  }

  /// Returns the data if Success, otherwise returns null
  T? getOrNull() {
    return when(onSuccess: (data) => data, onFailure: (_) => null);
  }

  /// Returns the exception if Failure, otherwise returns null
  NetworkException? getExceptionOrNull() {
    return when(onSuccess: (_) => null, onFailure: (exception) => exception);
  }

  /// Throws the exception if this is a Failure, otherwise returns the data
  T getOrThrow() {
    return when(
      onSuccess: (data) => data,
      onFailure: (exception) => throw exception,
    );
  }
}

/// Represents a successful result with data
final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  String toString() => 'Success(data: $data)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;
}

/// Represents a failed result with an exception
final class Failure<T> extends Result<T> {
  final NetworkException exception;

  const Failure(this.exception);

  @override
  String toString() => 'Failure(exception: $exception)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          runtimeType == other.runtimeType &&
          exception == other.exception;

  @override
  int get hashCode => exception.hashCode;
}

/// Extension methods for working with Result
extension ResultExtensions<T> on Result<T> {
  /// Folds the result into a single value
  R fold<R>(
    R Function(NetworkException exception) onFailure,
    R Function(T data) onSuccess,
  ) {
    return when(onSuccess: onSuccess, onFailure: onFailure);
  }
}

/// Extension for Future<Result<T>>
extension FutureResultExtensions<T> on Future<Result<T>> {
  /// Maps the success value asynchronously
  Future<Result<R>> mapAsync<R>(Future<R> Function(T data) mapper) async {
    final result = await this;
    return result.when(
      onSuccess: (data) async => Result.success(await mapper(data)),
      onFailure: (exception) => Result.failure(exception),
    );
  }

  /// Handles the result asynchronously
  Future<R> whenAsync<R>({
    required Future<R> Function(T data) onSuccess,
    required Future<R> Function(NetworkException exception) onFailure,
  }) async {
    final result = await this;
    return result.when(
      onSuccess: (data) async => await onSuccess(data),
      onFailure: (exception) async => await onFailure(exception),
    );
  }
}
