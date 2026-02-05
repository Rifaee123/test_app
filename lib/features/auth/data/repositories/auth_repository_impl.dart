import 'package:test_app/core/entities/user.dart';
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

    try {
      final result = await _networkService.post(
        ApiEndpoints.login,
        data: requestDto.toJson(),
      );

      if (result.isSuccess) {
        final data = result.getOrThrow();
        final responseModel = LoginResponseModel.fromJson(
          data as Map<String, dynamic>,
        );
        final user = LoginResponseMapperFactory.mapResponse(responseModel);

        // Save token and role if user has them
        // We prioritize the token from response model if available directly
        final token = responseModel.token ?? user.token;
        final userRole = responseModel.role ?? user.role;
        final userId =
            responseModel.studentId ?? responseModel.username ?? user.id;

        if (token != null) {
          await _localStorageService.saveToken(token);
        }

        if (userId.isNotEmpty) {
          await _localStorageService.saveUserId(userId);
        }

        // Save role (always available from entity now)
        await _localStorageService.saveRole(userRole);

        return Result.success(user);
      } else {
        return Result.failure(
          result.getExceptionOrNull() ??
              UnknownNetworkException(message: 'Unknown error occurred'),
        );
      }
    } catch (e) {
      if (e is NetworkException) {
        return Result.failure(e);
      }
      return Result.failure(
        UnknownNetworkException(
          message: 'Login failed: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Result<void>> logout() async {
    // Implement logout API call when endpoint is available (optional)

    // Clear local token and role
    await _localStorageService.clearToken();
    await _localStorageService.clearRole();
    await _localStorageService.clearUserId();

    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(null);
  }
}
