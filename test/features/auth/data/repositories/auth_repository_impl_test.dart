import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/core/network/exceptions/network_exception.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/network/network_service.dart';
import 'package:test_app/core/storage/local_storage_service.dart';
import 'package:test_app/core/network/result.dart';
import 'package:test_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:test_app/core/network/api_endpoints.dart';

class MockNetworkService extends Mock implements NetworkService {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

void main() {
  late AuthRepositoryImpl repository;
  late MockNetworkService mockNetworkService;
  late MockLocalStorageService mockLocalStorageService;

  setUp(() {
    mockNetworkService = MockNetworkService();
    mockLocalStorageService = MockLocalStorageService();
    repository = AuthRepositoryImpl(
      mockNetworkService,
      mockLocalStorageService,
    );

    // Default mocks
    when(
      () => mockLocalStorageService.saveToken(any()),
    ).thenAnswer((_) async {});
    when(
      () => mockLocalStorageService.saveRole(any()),
    ).thenAnswer((_) async {});
    when(
      () => mockLocalStorageService.saveUserId(any()),
    ).thenAnswer((_) async {});
  });

  const tUsername = 'student1';
  const tPassword = 'password';
  const tRole = 'STUDENT';

  final tLoginResponseMap = {
    'username': tUsername,
    'studentId': 'S123',
    'token': 'jwt_token',
    'role': 'STUDENT',
  };

  group('login', () {
    test(
      'should return success and save data when network call is successful',
      () async {
        // Arrange
        when(
          () => mockNetworkService.post(
            ApiEndpoints.login,
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => Result.success(tLoginResponseMap));

        // Act
        final result = await repository.login(tUsername, tPassword, tRole);

        // Assert
        expect(result.isSuccess, true);

        // Verify persistence
        verify(() => mockLocalStorageService.saveToken('jwt_token')).called(1);
        verify(() => mockLocalStorageService.saveRole('STUDENT')).called(1);
        verify(() => mockLocalStorageService.saveUserId('S123')).called(1);
      },
    );

    test('should return failure when network call fails', () async {
      // Arrange
      const tException = UnknownNetworkException(message: 'Network Error');
      when(
        () => mockNetworkService.post(
          ApiEndpoints.login,
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async => Result.failure(tException));

      // Act
      final result = await repository.login(tUsername, tPassword, tRole);

      // Assert
      expect(result.isFailure, true);
      verifyNever(() => mockLocalStorageService.saveToken(any()));
    });
  });

  group('logout', () {
    test('should clear local storage', () async {
      // Arrange
      when(() => mockLocalStorageService.clearToken()).thenAnswer((_) async {});
      when(() => mockLocalStorageService.clearRole()).thenAnswer((_) async {});
      when(
        () => mockLocalStorageService.clearUserId(),
      ).thenAnswer((_) async {});

      // Act
      await repository.logout();

      // Assert
      verify(() => mockLocalStorageService.clearToken()).called(1);
      verify(() => mockLocalStorageService.clearRole()).called(1);
      verify(() => mockLocalStorageService.clearUserId()).called(1);
    });
  });
}
