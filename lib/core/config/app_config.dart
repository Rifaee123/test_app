/// Environment configuration
enum Environment { development, staging, production }

/// App configuration based on environment
class AppConfig {
  final Environment environment;
  final String apiBaseUrl;
  final bool enableLogging;
  final int maxRetries;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    this.enableLogging = false,
    this.maxRetries = 2,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
  });

  /// Development configuration
  /// Replace with your actual development API base URL
  /// Example: 'https://dev.yourapi.com' or 'http://localhost:3000'
  /// Note: Do NOT include '/api' here - it's handled by ApiEndpoints
  static const development = AppConfig(
    environment: Environment.development,
    apiBaseUrl: 'https://studentcrudtest-production.up.railway.app',
    enableLogging: true,
    maxRetries: 3,
  );

  /// Staging configuration
  /// Replace with your actual staging API base URL
  static const staging = AppConfig(
    environment: Environment.staging,
    apiBaseUrl:
        'https://your-staging-api.com', // TODO: Replace with your staging URL
    enableLogging: true,
    maxRetries: 2,
  );

  /// Production configuration
  /// Replace with your actual production API base URL
  static const production = AppConfig(
    environment: Environment.production,
    apiBaseUrl:
        'https://your-api.com', // TODO: Replace with your production URL
    enableLogging: false,
    maxRetries: 2,
  );

  /// Current environment (set this to switch environments)
  static const current =
      development; // Change to staging or production as needed

  bool get isDevelopment => environment == Environment.development;
  bool get isStaging => environment == Environment.staging;
  bool get isProduction => environment == Environment.production;
}
