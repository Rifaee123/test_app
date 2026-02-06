import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/test_ids.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_bloc.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_event.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_state.dart';
import 'package:test_app/features/auth/presentation/view/landing_page.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const LandingPage(),
      ),
    );
  }

  group('LandingPage Widget Tests', () {
    testWidgets('renders all initial widgets', (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Welcome to EduTrack'), findsOneWidget);
      expect(find.text('Please select your role to continue'), findsOneWidget);
      expect(find.text('Login as Student'), findsOneWidget);
      expect(find.text('Login as Admin'), findsOneWidget);
      expect(find.byIcon(Icons.school_rounded), findsOneWidget);
    });

    testWidgets(
      'adds NavigateToLoginRequested(isAdmin: false) when Student button is pressed',
      (tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthInitial());

        await tester.pumpWidget(createWidgetUnderTest());

        await tester.tap(find.text('Login as Student'));
        await tester.pump();

        verify(
          () =>
              mockAuthBloc.add(const NavigateToLoginRequested(isAdmin: false)),
        ).called(1);
      },
    );

    testWidgets(
      'adds NavigateToLoginRequested(isAdmin: true) when Admin button is pressed',
      (tester) async {
        when(() => mockAuthBloc.state).thenReturn(AuthInitial());

        await tester.pumpWidget(createWidgetUnderTest());

        await tester.tap(find.text('Login as Admin'));
        await tester.pump();

        verify(
          () => mockAuthBloc.add(const NavigateToLoginRequested(isAdmin: true)),
        ).called(1);
      },
    );
  });
}
