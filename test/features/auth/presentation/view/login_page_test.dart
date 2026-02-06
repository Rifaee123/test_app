import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/test_ids.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_bloc.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_event.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_state.dart';
import 'package:test_app/features/auth/presentation/view/login_page.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  Widget createWidgetUnderTest({bool isAdmin = false}) {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: LoginPage(isAdmin: isAdmin),
      ),
    );
  }

  group('LoginPage Widget Tests', () {
    testWidgets('renders all initial widgets for Student', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());

      await tester.pumpWidget(createWidgetUnderTest(isAdmin: false));

      expect(find.text('Welcome to EduTrack'), findsOneWidget);
      expect(
        find.text('Sign in to continue your education portal'),
        findsOneWidget,
      );
      expect(find.byKey(const Key(TestIds.studentIdInput)), findsOneWidget);
      expect(find.byKey(const Key(TestIds.passwordInput)), findsOneWidget);
      expect(find.byKey(const Key(TestIds.loginButton)), findsOneWidget);
      expect(find.text('Student ID'), findsOneWidget);
    });

    testWidgets('renders all initial widgets for Admin', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());

      await tester.pumpWidget(createWidgetUnderTest(isAdmin: true));

      expect(find.text('Welcome to EduTrack'), findsOneWidget);
      expect(find.text('Sign in to access admin dashboard'), findsOneWidget);
      expect(find.text('Admin ID'), findsOneWidget);
    });

    testWidgets(
      'adds LoginRequested to AuthBloc when login button is pressed',
      (tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthInitial());

        await tester.pumpWidget(createWidgetUnderTest(isAdmin: false));

        await tester.enterText(
          find.byKey(const Key(TestIds.studentIdInput)),
          'STU1001',
        );
        await tester.enterText(
          find.byKey(const Key(TestIds.passwordInput)),
          'password123',
        );

        await tester.tap(find.byKey(const Key(TestIds.loginButton)));
        await tester.pump();

        verify(
          () => mockAuthBloc.add(
            const LoginRequested(
              studentId: 'STU1001',
              password: 'password123',
              isAdmin: false,
            ),
          ),
        ).called(1);
      },
    );

    testWidgets('shows CircularProgressIndicator when state is AuthLoading', (
      tester,
    ) async {
      when(() => mockAuthBloc.state).thenReturn(AuthLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Button should be disabled (onPressed is null)
      final loginButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(loginButton.onPressed, isNull);
    });

    testWidgets('shows SnackBar when state is AuthError', (tester) async {
      final states = [AuthInitial(), const AuthError('Invalid Credentials')];
      whenListen(mockAuthBloc, Stream.fromIterable(states));
      when(() => mockAuthBloc.state).thenReturn(states.last);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(); // Start BlocListener

      // Since SnackBar is shown on transition, we might need to pump again
      await tester.pump();

      expect(find.text('Invalid Credentials'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
