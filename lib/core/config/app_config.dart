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
  static const development = AppConfig(
    environment: Environment.development,
    apiBaseUrl: 'http://192.168.29.238:8081/api',
    enableLogging: true,
    maxRetries: 3,
  );

  /// Staging configuration
  static const staging = AppConfig(
    environment: Environment.staging,
    apiBaseUrl: 'https://staging-api.example.com',
    enableLogging: true,
    maxRetries: 2,
  );

  /// Production configuration
  static const production = AppConfig(
    environment: Environment.production,
    apiBaseUrl: 'https://api.example.com',
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
