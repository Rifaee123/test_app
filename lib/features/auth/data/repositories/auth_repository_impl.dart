import 'package:test_app/core/entities/user.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/entities/admin.dart';
import 'package:test_app/core/network/result.dart';
import 'package:test_app/core/network/api_endpoints.dart';
import 'package:test_app/core/network/exceptions/network_exception.dart';
import 'package:test_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:test_app/core/network/network_service.dart';
import 'package:test_app/features/auth/data/models/login_request_dto.dart';
import 'package:test_app/features/auth/data/models/login_response_dto.dart';
import 'package:test_app/features/auth/data/mappers/login_response_mapper.dart';
import 'package:test_app/core/storage/local_storage_service.dart';

/// Implementation of AuthRepository
/// Follows Dependency Inversion Principle - depends on NetworkService abstraction
/// Follows Single Responsibility Principle - only handles auth data operations
class AuthRepositoryImpl implements AuthRepository {
  final NetworkService _networkService;
  final LocalStorageService _localStorageService;

  AuthRepositoryImpl(this._networkService, this._localStorageService);

  @override
  Future<Result<User?>> login(
    String username,
    String password,
    String role,
  ) async {
    // Create request DTO
    final requestDto = LoginRequestDto(
      username: username,
      password: password,
      role: role,
    );

    // Make API call
    final result = await _networkService.post(
      ApiEndpoints.login,
      data: requestDto.toJson(),
    );

    // Handle result using functional approach with correct parameter names
    return result.when(
      onSuccess: (data) {
        try {
          // Parse response
          final responseModel = LoginResponseModel.fromJson(
            data as Map<String, dynamic>,
          );

          // Convert to User entity using mapper
          final user = LoginResponseMapperFactory.mapResponse(responseModel);

          // Save token if user has one (from response or entity)
          // We prioritize the token from response model if available directly
          if (responseModel.token != null) {
            _localStorageService.saveToken(responseModel.token!);
          } else if (user is Student && user.token != null) {
            _localStorageService.saveToken(user.token!);
          } else if (user is Admin && user.token != null) {
            _localStorageService.saveToken(user.token!);
          }

          return Result.success(user);
        } catch (e) {
          // Handle parsing errors - wrap in NetworkException
          return Result.failure(
            UnknownNetworkException(
              message: 'Failed to parse login response: ${e.toString()}',
              originalError: e,
            ),
          );
        }
      },
      onFailure: (error) {
        // Pass through network errors
        return Result.failure(error);
      },
    );
  }

  @override
  Future<Result<void>> logout() async {
    // Implement logout API call when endpoint is available (optional)

    // Clear local token
    await _localStorageService.clearToken();

    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(null);
  }
}
