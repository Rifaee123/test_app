# Network Error Handling Documentation

## Overview

The network layer now includes comprehensive error handling that transforms low-level Dio exceptions into domain-specific exceptions. This provides better error messages, decouples the application from Dio-specific errors, and enables consistent error handling across the app.

## Exception Hierarchy

```
NetworkException (abstract base)
├── ConnectionException      - Network connectivity issues
├── TimeoutException        - Request timeouts
├── ServerException         - Server errors (4xx, 5xx)
├── RequestCancelledException - Cancelled requests
├── ParseException          - Response parsing failures
└── UnknownNetworkException - Unexpected errors
```

## Exception Types

### 1. **ConnectionException**

Thrown when there's a network connectivity issue.

**Common Causes:**

- No internet connection
- DNS resolution failure
- SSL/TLS certificate errors
- Network unreachable

**Default Message:** "Unable to connect to the server. Please check your internet connection."

### 2. **TimeoutException**

Thrown when a request exceeds the configured timeout.

**Dio Exception Types Mapped:**

- `DioExceptionType.connectionTimeout`
- `DioExceptionType.sendTimeout`
- `DioExceptionType.receiveTimeout`

**Default Message:** "Request timed out. Please try again."

### 3. **ServerException**

Thrown when the server returns an error response (4xx, 5xx status codes).

**Properties:**

- `statusCode`: HTTP status code
- `message`: Error message (extracted from server response or default)

**Status Code Messages:**

- `400` - Bad request. Please check your input.
- `401` - Unauthorized. Please log in again.
- `403` - Access forbidden. You don't have permission to access this resource.
- `404` - Resource not found.
- `408` - Request timeout. Please try again.
- `429` - Too many requests. Please try again later.
- `500` - Internal server error. Please try again later.
- `502` - Bad gateway. Please try again later.
- `503` - Service unavailable. Please try again later.

### 4. **RequestCancelledException**

Thrown when a request is explicitly cancelled.

**Default Message:** "Request was cancelled."

### 5. **UnknownNetworkException**

Thrown for unexpected errors that don't fit other categories.

**Default Message:** "An unexpected error occurred. Please try again."

## Usage Examples

### Basic Error Handling in Repository

```dart
class UserRepositoryImpl implements UserRepository {
  final NetworkService _networkService;

  @override
  Future<User> getUser(String id) async {
    try {
      final data = await _networkService.get('/users/$id');
      return User.fromJson(data);
    } on ServerException catch (e) {
      if (e.statusCode == 404) {
        throw UserNotFoundException('User not found');
      }
      rethrow;
    } on ConnectionException {
      throw NetworkUnavailableException();
    } on NetworkException {
      // Handle all other network exceptions
      rethrow;
    }
  }
}
```

### Error Handling in BLoC

```dart
Future<void> _onLoadUserRequested(
  LoadUserRequested event,
  Emitter<UserState> emit,
) async {
  emit(UserLoading());
  try {
    final user = await _repository.getUser(event.userId);
    emit(UserLoaded(user));
  } on ServerException catch (e) {
    if (e.statusCode == 401) {
      emit(UserError('Please log in again'));
    } else {
      emit(UserError(e.message));
    }
  } on TimeoutException {
    emit(UserError('Request timed out. Please try again.'));
  } on ConnectionException {
    emit(UserError('No internet connection. Please check your network.'));
  } on NetworkException catch (e) {
    emit(UserError(e.message));
  }
}
```

### Displaying User-Friendly Messages

```dart
void _showError(NetworkException error) {
  String message;

  if (error is ConnectionException) {
    message = 'Please check your internet connection';
  } else if (error is TimeoutException) {
    message = 'The request is taking too long. Please try again.';
  } else if (error is ServerException) {
    message = error.message; // Already user-friendly
  } else {
    message = 'Something went wrong. Please try again.';
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
```

## Server Message Extraction

The `DioNetworkService` automatically attempts to extract error messages from server responses using common patterns:

```json
// Supported response formats:
{
  "message": "Error message"
}

{
  "error": "Error message"
}

{
  "errorMessage": "Error message"
}

{
  "msg": "Error message"
}
```

If no message is found, a default message based on the status code is used.

## Benefits

1. **Decoupling**: Application code is decoupled from Dio-specific exceptions
2. **Consistency**: Uniform error handling across the entire app
3. **User-Friendly**: Meaningful error messages for end users
4. **Testability**: Easy to mock and test error scenarios
5. **Maintainability**: Centralized error handling logic
6. **Extensibility**: Easy to add new exception types as needed

## Best Practices

1. **Catch Specific Exceptions First**: Always catch more specific exceptions before generic ones
2. **Provide Context**: Add domain-specific context when rethrowing exceptions
3. **Log Original Errors**: Use the `originalError` property for debugging
4. **Don't Expose Technical Details**: Transform technical errors into user-friendly messages
5. **Handle All Cases**: Always have a fallback for unexpected errors

## Migration Guide

If you have existing code catching `DioException`, update it to catch `NetworkException` instead:

**Before:**

```dart
try {
  await _networkService.get('/endpoint');
} on DioException catch (e) {
  // Handle error
}
```

**After:**

```dart
try {
  await _networkService.get('/endpoint');
} on ServerException catch (e) {
  // Handle server errors
} on ConnectionException catch (e) {
  // Handle connection errors
} on NetworkException catch (e) {
  // Handle all other network errors
}
```
