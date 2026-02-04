# Environment Configuration Guide

## Overview

The app now uses environment-based configuration to automatically switch between development, staging, and production settings. No more manual code changes!

## Configuration File

**Location**: [`lib/core/config/app_config.dart`](file:///c:/Users/AKSHAY.KUMAR/test_app/lib/core/config/app_config.dart)

## Available Environments

### 1. Development

```dart
AppConfig.development
```

- **API URL**: `https://dev-api.example.com`
- **Logging**: Enabled
- **Max Retries**: 3
- **Use for**: Local development and debugging

### 2. Staging

```dart
AppConfig.staging
```

- **API URL**: `https://staging-api.example.com`
- **Logging**: Enabled
- **Max Retries**: 2
- **Use for**: Testing before production

### 3. Production

```dart
AppConfig.production
```

- **API URL**: `https://api.example.com`
- **Logging**: Disabled
- **Max Retries**: 2
- **Use for**: Live production app

## How to Switch Environments

### Method 1: Change in AppConfig (Simple)

Open [`app_config.dart`](file:///c:/Users/AKSHAY.KUMAR/test_app/lib/core/config/app_config.dart) and change line 51:

```dart
// For development
static const current = development;

// For staging
static const current = staging;

// For production
static const current = production;
```

### Method 2: Using Dart Define (Recommended for CI/CD)

1. **Update `app_config.dart`** to read from environment variable:

```dart
static const current = String.fromEnvironment('ENV') == 'production'
    ? production
    : String.fromEnvironment('ENV') == 'staging'
        ? staging
        : development;
```

2. **Run with environment variable**:

```bash
# Development (default)
flutter run

# Staging
flutter run --dart-define=ENV=staging

# Production
flutter run --dart-define=ENV=production

# Build for production
flutter build apk --dart-define=ENV=production
```

### Method 3: Separate Entry Points (Advanced)

Create separate main files for each environment:

**`lib/main_dev.dart`**:

```dart
import 'package:test_app/core/config/app_config.dart';
import 'main.dart' as app;

void main() {
  // Force development config
  app.runAppWithConfig(AppConfig.development);
}
```

**`lib/main_prod.dart`**:

```dart
import 'package:test_app/core/config/app_config.dart';
import 'main.dart' as app;

void main() {
  // Force production config
  app.runAppWithConfig(AppConfig.production);
}
```

Run with:

```bash
flutter run -t lib/main_dev.dart
flutter run -t lib/main_prod.dart
```

## Customizing Configuration

### Update API URLs

Edit the URLs in `app_config.dart`:

```dart
static const development = AppConfig(
  environment: Environment.development,
  apiBaseUrl: 'https://your-dev-api.com', // ← Change this
  enableLogging: true,
  maxRetries: 3,
);
```

### Add New Configuration Values

```dart
class AppConfig {
  final String apiBaseUrl;
  final bool enableLogging;
  final String apiKey;        // ← Add new field
  final int cacheTimeout;     // ← Add new field

  const AppConfig({
    required this.apiBaseUrl,
    this.enableLogging = false,
    this.apiKey = '',         // ← Add to constructor
    this.cacheTimeout = 300,  // ← Add to constructor
  });

  static const development = AppConfig(
    apiBaseUrl: '...',
    apiKey: 'dev-key-123',    // ← Set for dev
    cacheTimeout: 60,
  );
}
```

## Current Setup

The DI configuration in [`injection.dart`](file:///c:/Users/AKSHAY.KUMAR/test_app/lib/core/di/injection.dart) automatically uses the current environment:

```dart
sl.registerLazySingleton(() {
  final config = AppConfig.current;
  return DioConfig.createDio(
    baseUrl: config.apiBaseUrl,
    connectTimeout: config.connectTimeout,
    receiveTimeout: config.receiveTimeout,
    enableLogging: config.enableLogging,
    maxRetries: config.maxRetries,
    authInterceptor: sl<AuthInterceptor>(),
  );
});
```

## Benefits

✅ **Single Source of Truth**: All environment settings in one place  
✅ **Type Safe**: Compile-time checking of configuration  
✅ **Easy Switching**: Change one line to switch environments  
✅ **CI/CD Ready**: Use dart-define for automated builds  
✅ **No Code Changes**: Switch environments without modifying code

## Best Practices

1. **Never commit production credentials** to version control
2. **Use environment variables** for sensitive data (API keys, secrets)
3. **Test in staging** before deploying to production
4. **Keep development logging enabled** for debugging
5. **Disable logging in production** for performance and security

## Troubleshooting

### Wrong API URL being used

- Check `AppConfig.current` value
- Verify you're running with correct dart-define flag
- Rebuild the app after changing configuration

### Logging not working

- Check `enableLogging` is true for current environment
- Verify you're in debug mode (logging may be stripped in release builds)

### Changes not taking effect

- Hot reload may not work for config changes
- Do a full restart: `flutter run` (not hot reload)
