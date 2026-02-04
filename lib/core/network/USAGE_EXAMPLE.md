# API Configuration Usage Guide

## Overview

Your API is now configured with the URL pattern: `{{baseURL}}/api/auth/login`

## How It Works

### 1. Base URL Configuration

**File**: [`app_config.dart`](file:///c:/Users/AKSHAY.KUMAR/test_app/lib/core/config/app_config.dart)

Set your actual API base URL (without `/api`):

```dart
static const development = AppConfig(
  environment: Environment.development,
  apiBaseUrl: 'https://your-dev-api.com', // Replace with your actual URL
  enableLogging: true,
  maxRetries: 3,
);
```

### 2. API Endpoints

**File**: [`api_endpoints.dart`](file:///c:/Users/AKSHAY.KUMAR/test_app/lib/core/network/api_endpoints.dart)

All endpoints include the `/api` prefix:

```dart
ApiEndpoints.login        // '/api/auth/login'
ApiEndpoints.register     // '/api/auth/register'
ApiEndpoints.userProfile  // '/api/user/profile'
```

### 3. Making API Calls

The `DioNetworkService` automatically combines the base URL with the endpoint path.

#### Example: Login Request

```dart
import 'package:test_app/core/network/api_endpoints.dart';
import 'package:test_app/core/network/network_service.dart';

class AuthRepository {
  final NetworkService _networkService;

  AuthRepository(this._networkService);

  Future<Result<dynamic>> login(String email, String password) async {
    return await _networkService.post(
      ApiEndpoints.login,  // Uses '/api/auth/login'
      data: {
        'email': email,
        'password': password,
      },
    );
  }
}
```

**Full URL**: `https://your-dev-api.com/api/auth/login`

#### Example: Get User Profile

```dart
Future<Result<dynamic>> getUserProfile() async {
  return await _networkService.get(
    ApiEndpoints.userProfile,  // Uses '/api/user/profile'
  );
}
```

**Full URL**: `https://your-dev-api.com/api/user/profile`

#### Example: Register User

```dart
Future<Result<dynamic>> register(Map<String, dynamic> userData) async {
  return await _networkService.post(
    ApiEndpoints.register,  // Uses '/api/auth/register'
    data: userData,
  );
}
```

## Adding New Endpoints

To add a new endpoint, update [`api_endpoints.dart`](file:///c:/Users/AKSHAY.KUMAR/test_app/lib/core/network/api_endpoints.dart):

```dart
class ApiEndpoints {
  static const String _apiBase = '/api';

  // Your new endpoint
  static const String products = '$_apiBase/products';
  static const String productDetails = '$_apiBase/products/details';
}
```

Then use it in your repository:

```dart
Future<Result<dynamic>> getProducts() async {
  return await _networkService.get(ApiEndpoints.products);
}
```

## URL Structure Breakdown

| Component    | Value                               | Example                                   |
| ------------ | ----------------------------------- | ----------------------------------------- |
| **Base URL** | From `AppConfig.current.apiBaseUrl` | `https://your-dev-api.com`                |
| **Endpoint** | From `ApiEndpoints`                 | `/api/auth/login`                         |
| **Full URL** | Base + Endpoint                     | `https://your-dev-api.com/api/auth/login` |

## Quick Setup Checklist

- [x] ✅ `api_endpoints.dart` - Endpoints defined with `/api` prefix
- [x] ✅ `app_config.dart` - Base URLs configured (update with your actual URLs)
- [x] ✅ `dio_network_service.dart` - Already handles URL combination
- [ ] 🔧 **TODO**: Replace placeholder URLs in `app_config.dart` with your actual API URLs

## Next Steps

1. **Update Base URLs**: Edit [`app_config.dart`](file:///c:/Users/AKSHAY.KUMAR/test_app/lib/core/config/app_config.dart) with your actual API URLs
2. **Add More Endpoints**: Add your API endpoints to [`api_endpoints.dart`](file:///c:/Users/AKSHAY.KUMAR/test_app/lib/core/network/api_endpoints.dart)
3. **Use in Repositories**: Import `ApiEndpoints` and use with `NetworkService`

## Example Repository Implementation

```dart
import 'package:test_app/core/network/api_endpoints.dart';
import 'package:test_app/core/network/network_service.dart';
import 'package:test_app/core/network/result.dart';

class UserRepository {
  final NetworkService _networkService;

  UserRepository(this._networkService);

  // Login
  Future<Result<dynamic>> login(String email, String password) async {
    return await _networkService.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
  }

  // Get Profile
  Future<Result<dynamic>> getProfile() async {
    return await _networkService.get(ApiEndpoints.userProfile);
  }

  // Update Profile
  Future<Result<dynamic>> updateProfile(Map<String, dynamic> data) async {
    return await _networkService.put(
      ApiEndpoints.updateUser,
      data: data,
    );
  }

  // Logout
  Future<Result<dynamic>> logout() async {
    return await _networkService.post(ApiEndpoints.logout);
  }
}
```
