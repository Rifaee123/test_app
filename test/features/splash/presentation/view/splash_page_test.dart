import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/test_ids.dart';
import 'package:test_app/features/splash/presentation/presenter/splash_bloc.dart';
import 'package:test_app/features/splash/presentation/presenter/splash_event.dart';
import 'package:test_app/features/splash/presentation/presenter/splash_state.dart';
import 'package:test_app/features/splash/presentation/view/splash_page.dart';

class MockSplashBloc extends MockBloc<SplashEvent, SplashState>
    implements SplashBloc {}

void main() {
  late MockSplashBloc mockSplashBloc;

  setUpAll(() {
    GetIt.instance.allowReassignment = true;
  });

  setUp(() {
    mockSplashBloc = MockSplashBloc();
    GetIt.instance.registerFactory<SplashBloc>(() => mockSplashBloc);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  Widget createWidgetUnderTest() {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => const MaterialApp(home: SplashPage()),
    );
  }

  group('SplashPage Widget Tests', () {
    testWidgets('renders all branding elements and loading text', (
      tester,
    ) async {
      when(() => mockSplashBloc.state).thenReturn(SplashInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('EduTrack'), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
      expect(find.byIcon(Icons.school_rounded), findsOneWidget);
    });

    testWidgets('adds CheckAuthStatus event on initialization', (tester) async {
      when(() => mockSplashBloc.state).thenReturn(SplashInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      verify(
        () => mockSplashBloc.add(any(that: isA<CheckAuthStatus>())),
      ).called(1);
    });
  });
}
