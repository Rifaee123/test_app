import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_app/core/di/injection.dart';
import 'package:test_app/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:test_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:test_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:test_app/main.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

class MockAdminBloc extends Mock implements AdminBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockAdminBloc mockAdminBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockAdminBloc = MockAdminBloc();

    // Mock states to prevent BlocBuilder from breaking
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    when(() => mockAdminBloc.state).thenReturn(AdminLoading());

    sl.reset();
    sl.registerFactory<AuthBloc>(() => mockAuthBloc);
    sl.registerFactory<AdminBloc>(() => mockAdminBloc);
  });

  testWidgets('App loads admin home page', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ScreenUtilInit(designSize: Size(390, 844), child: EduTrackApp()),
    );
    await tester.pump();
    expect(find.text('Admin Portal'), findsOneWidget);
  });
}
