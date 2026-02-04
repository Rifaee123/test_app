import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/di/injection.dart';
import 'package:test_app/core/entities/teacher.dart';
import 'package:test_app/features/admin/presentation/presenter/admin_presenter.dart';
import 'package:test_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:test_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:test_app/main.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

class MockAdminPresenter extends Mock implements AdminPresenter {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockAdminPresenter mockAdminPresenter;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockAdminPresenter = MockAdminPresenter();

    // Mock states to prevent BlocBuilder from breaking
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());

    const mockTeacher = Teacher(
      id: '1',
      name: 'Test Teacher',
      email: 'test@test.com',
      subject: 'Math',
      department: 'Math',
    );
    when(
      () => mockAdminPresenter.state,
    ).thenReturn(AdminLoaded(teacher: mockTeacher, students: const []));

    sl.reset();
    sl.registerFactory<AuthBloc>(() => mockAuthBloc);
    sl.registerFactory<AdminPresenter>(() => mockAdminPresenter);
  });

  testWidgets('App loads admin home page', (WidgetTester tester) async {
    await tester.pumpWidget(const EduTrackApp());
    await tester.pumpAndSettle();
    expect(find.text('Students Management'), findsOneWidget);
  });
}
