import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/core/config/app_config.dart';
import 'package:test_app/core/di/injection.dart';
import 'package:test_app/core/theme/app_theme.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_bloc.dart';
import 'package:test_app/features/auth/presentation/view/landing_page.dart';
import 'package:test_app/core/services/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDI();

  runApp(const EduTrackApp());
}

class EduTrackApp extends StatelessWidget {
  const EduTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [BlocProvider(create: (_) => sl<AuthBloc>())],
          child: MaterialApp(
            title: 'EduTrack',
            navigatorKey: sl<NavigationService>().navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: const LandingPage(),
          ),
        );
      },
    );
  }
}
