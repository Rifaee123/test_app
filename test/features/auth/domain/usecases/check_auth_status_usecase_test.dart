import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/storage/local_storage_service.dart';
import 'package:test_app/features/auth/domain/usecases/check_auth_status_usecase.dart';

class MockLocalStorageService extends Mock implements LocalStorageService {}

void main() {
  late CheckAuthStatusUseCase useCase;
  late MockLocalStorageService mockStorage;

  setUp(() {
    mockStorage = MockLocalStorageService();
    useCase = CheckAuthStatusUseCase(mockStorage);
  });

  test('should return unauthenticated when token does not exist', () async {
    // Arrange
    when(() => mockStorage.hasToken()).thenAnswer((_) async => false);

    // Act
    final result = await useCase.execute();

    // Assert
    expect(result.isAuthenticated, false);
    verify(() => mockStorage.hasToken()).called(1);
    verifyNever(() => mockStorage.getToken());
  });

  test('should return authenticated with details when token exists', () async {
    // Arrange
    when(() => mockStorage.hasToken()).thenAnswer((_) async => true);
    when(() => mockStorage.getToken()).thenAnswer((_) async => 'token123');
    when(() => mockStorage.getRole()).thenAnswer((_) async => 'STUDENT');
    when(() => mockStorage.getUserId()).thenAnswer((_) async => 'S123');

    // Act
    final result = await useCase.execute();

    // Assert
    expect(result.isAuthenticated, true);
    expect(result.token, 'token123');
    expect(result.role, 'STUDENT');
    expect(result.userId, 'S123');
  });
}
