# Dio Interceptors Documentation

## Overview

Dio interceptors allow you to intercept requests, responses, and errors before they are handled by the application. This enables powerful features like logging, authentication, retry logic, and more.

## Available Interceptors

### 1. LoggingInterceptor

Logs all HTTP requests, responses, and errors for debugging purposes.

**Features:**

- Logs request method, URL, headers, query parameters, and body
- Logs response status code, headers, and data
- Logs errors with type, message, and response data
- Hides sensitive headers (e.g., Authorization)
- Formatted output for easy reading

**Configuration:**

```dart
LoggingInterceptor(
  logRequest: true,   // Log requests
  logResponse: true,  // Log responses
  logError: true,     // Log errors
)
```

**Example Output:**

```
┌─────────────────────────────────────────────────────────
│ REQUEST
├─────────────────────────────────────────────────────────
│ Method: POST
│ URL: https://api.example.com/login
│ Headers:
│   Content-Type: application/json
│   Authorization: ***
│ Body: {id: STU1001, password: ******}
└─────────────────────────────────────────────────────────
```

### 2. AuthInterceptor

Automatically adds authentication tokens to requests and handles token expiration.

**Features:**

- Automatically adds `Authorization: Bearer <token>` header to all requests
- Clears token on 401 Unauthorized responses
- Simple API for setting and clearing tokens

**Usage:**

```dart
final authInterceptor = AuthInterceptor();

// Set token after login
authInterceptor.setToken('your-jwt-token');

// Clear token on logout
authInterceptor.clearToken();

// Check current token
final currentToken = authInterceptor.token;
```

### 3. RetryInterceptor

Automatically retries failed requests with exponential backoff.

**Features:**

- Retries on connection timeouts, send/receive timeouts, and connection errors
- Exponential backoff (delay increases with each retry)
- Configurable max retries and retry delay
- Configurable retryable error types

**Configuration:**

```dart
RetryInterceptor(
  maxRetries: 3,                          // Maximum number of retries
  retryDelay: Duration(seconds: 1),       // Base delay between retries
  retryableErrors: [                      // Which errors to retry
    DioExceptionType.connectionTimeout,
    DioExceptionType.sendTimeout,
    DioExceptionType.receiveTimeout,
    DioExceptionType.connectionError,
  ],
)
```

**Retry Logic:**

- 1st retry: Wait 1 second
- 2nd retry: Wait 2 seconds
- 3rd retry: Wait 3 seconds
- After max retries: Return error

## Setup and Configuration

### Using DioConfig (Recommended)

The `DioConfig` class provides factory methods for easy Dio setup:

```dart
// Development setup (with logging)
final dio = DioConfig.createDevDio(
  baseUrl: 'https://api.example.com',
);

// Production setup (without logging)
final dio = DioConfig.createProdDio(
  baseUrl: 'https://api.example.com',
);

// Custom configuration
final dio = DioConfig.createDio(
  baseUrl: 'https://api.example.com',
  connectTimeout: Duration(seconds: 30),
  receiveTimeout: Duration(seconds: 30),
  enableLogging: true,
  enableRetry: true,
  maxRetries: 3,
);
```

### Manual Setup

```dart
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.example.com',
  connectTimeout: Duration(seconds: 30),
  receiveTimeout: Duration(seconds: 30),
));

// Add interceptors in order
dio.interceptors.add(LoggingInterceptor());
dio.interceptors.add(AuthInterceptor());
dio.interceptors.add(RetryInterceptor(maxRetries: 3));
```

### Interceptor Order Matters

Interceptors are executed in the order they are added:

1. **LoggingInterceptor** - First, to log everything
2. **AuthInterceptor** - Second, to add auth headers
3. **RetryInterceptor** - Last, to retry failed requests

## Integration with DioNetworkService

Update your DI setup to use the configured Dio instance:

```dart
// In your dependency injection setup
final authInterceptor = AuthInterceptor();

final dio = DioConfig.createDevDio(
  baseUrl: 'https://api.example.com',
  authInterceptor: authInterceptor,
);

final networkService = DioNetworkService(dio);
```

## Managing Authentication

### Setting Token After Login

```dart
class AuthInteractor {
  final AuthInterceptor _authInterceptor;
  final LoginUseCase _loginUseCase;

  Future<Result<User?>> executeLogin({
    required AuthId authId,
    required Password password,
  }) async {
    final result = await _loginUseCase.execute(
      authId: authId,
      password: password,
    );

    result.whenSuccess((user) {
      if (user != null) {
        // Set token in interceptor
        _authInterceptor.setToken(user.authToken);
      }
    });

    return result;
  }

  Future<Result<void>> executeLogout() async {
    // Clear token on logout
    _authInterceptor.clearToken();
    return _logoutUseCase.execute();
  }
}
```

### Accessing AuthInterceptor

You need to pass the `AuthInterceptor` instance to components that need to manage tokens:

```dart
// In your DI setup
final authInterceptor = AuthInterceptor();
final dio = DioConfig.createDevDio(
  baseUrl: baseUrl,
  authInterceptor: authInterceptor,
);

// Pass to interactor
final authInteractor = AuthInteractor(
  loginUseCase,
  logoutUseCase,
  navigation,
  authInterceptor, // Add this parameter
);
```

## Production vs Development

### Development

```dart
final dio = DioConfig.createDevDio(
  baseUrl: 'https://dev-api.example.com',
);
```

- Logging enabled
- 3 retries
- Verbose error messages

### Production

```dart
final dio = DioConfig.createProdDio(
  baseUrl: 'https://api.example.com',
);
```

- Logging disabled
- 2 retries
- Clean error messages

## Custom Interceptors

You can create custom interceptors by extending `Interceptor`:

```dart
class CustomHeaderInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-Custom-Header'] = 'value';
    super.onRequest(options, handler);
  }
}

// Add to Dio
dio.interceptors.add(CustomHeaderInterceptor());
```

## Best Practices

1. **Order Matters**: Add interceptors in the correct order
2. **Development vs Production**: Use different configs for dev and prod
3. **Sensitive Data**: Never log sensitive data (passwords, tokens)
4. **Retry Logic**: Only retry idempotent requests (GET, PUT, DELETE)
5. **Token Management**: Clear tokens on logout and 401 errors
6. **Performance**: Disable logging in production
7. **Error Handling**: Let the Result wrapper handle errors, interceptors just transform them

## Troubleshooting

### Requests not being retried

- Check if the error type is in `retryableErrors`
- Verify `maxRetries` is greater than 0
- Check if `enableRetry` is true

### Token not being added

- Verify `setToken()` was called
- Check if `AuthInterceptor` is added to Dio
- Ensure token is not null or empty

### Logs not appearing

- Verify `enableLogging` is true
- Check if `LoggingInterceptor` is added
- Ensure you're in debug mode

## Example: Complete Setup

```dart
// 1. Create auth interceptor
final authInterceptor = AuthInterceptor();

// 2. Create Dio with interceptors
final dio = DioConfig.createDevDio(
  baseUrl: 'https://api.example.com',
  authInterceptor: authInterceptor,
);

// 3. Create network service
final networkService = DioNetworkService(dio);

// 4. Create repository
final authRepository = AuthRepositoryImpl(networkService);

// 5. Create use cases
final loginUseCase = LoginUseCase(authRepository);

// 6. Create interactor (with auth interceptor access)
final authInteractor = AuthInteractor(
  loginUseCase,
  logoutUseCase,
  navigation,
  authInterceptor,
);

// 7. Use in your app
final result = await authInteractor.executeLogin(...);
result.whenSuccess((user) {
  // Token is automatically set in AuthInterceptor
  // All subsequent requests will include the token
});
```
