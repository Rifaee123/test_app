import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/di/injection.dart';
import 'package:test_app/core/entities/teacher.dart';
import 'package:test_app/features/admin/presentation/presenter/admin_presenter.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_bloc.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_state.dart';
import 'package:test_app/main.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

class MockAdminDashboardBloc extends Mock implements AdminDashboardBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockAdminDashboardBloc mockAdminDashboardBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockAdminDashboardBloc = MockAdminDashboardBloc();

    // Mock states to prevent BlocBuilder from breaking
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());

    const mockTeacher = Teacher(
      id: '1',
      name: 'Test Teacher',
      email: 'test@test.com',
      subject: 'Math',
      department: 'Math',
    );
    when(() => mockAdminDashboardBloc.state).thenReturn(
      AdminLoaded(teacher: mockTeacher, students: const [], stats: const []),
    );

    sl.reset();
    sl.registerFactory<AuthBloc>(() => mockAuthBloc);
    sl.registerFactory<AdminDashboardBloc>(() => mockAdminDashboardBloc);
  });

  testWidgets('App loads admin home page', (WidgetTester tester) async {
    await tester.pumpWidget(const EduTrackApp());
    await tester.pumpAndSettle();
    expect(find.text('Students Management'), findsOneWidget);
  });
}
