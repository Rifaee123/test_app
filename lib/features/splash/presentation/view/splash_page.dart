import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_app/features/splash/presentation/view/splash_keys.dart';
import 'package:test_app/core/di/injection.dart';
import 'package:test_app/core/theme/app_theme.dart';
import 'package:test_app/features/splash/presentation/presenter/splash_bloc.dart';
import 'package:test_app/features/splash/presentation/presenter/splash_event.dart';
import 'package:test_app/features/splash/presentation/presenter/splash_state.dart';
import 'package:shimmer/shimmer.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SplashBloc>()..add(CheckAuthStatus()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          // Navigation is handled by Bloc (or Router called by Bloc)
          // But explicitly, Bloc calls router methods which use context-less navigation
          // so we don't strictly need to listen here for navigation if Router uses GlobalKey.
          // However, CheckAuthStatus logic in Bloc calls _navigation which uses GlobalKey.
        },
        child: Scaffold(
          key: SplashKeys.splashPage,
          backgroundColor: AppTheme.primaryColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or Title
                Icon(
                  Icons.school_rounded,
                  key: SplashKeys.appLogo,
                  size: 80.sp,
                  color: Colors.white,
                ),
                SizedBox(height: 20.h),
                Text(
                  'EduTrack',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 40.h),
                // Loading Indicator
                Shimmer.fromColors(
                  key: SplashKeys.loadingIndicator,
                  baseColor: Colors.white.withOpacity(0.5),
                  highlightColor: Colors.white,
                  child: Text(
                    'Loading...',
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
