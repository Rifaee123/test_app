import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:test_app/core/config/app_config.dart';
import 'package:test_app/core/network/dio_builder.dart';
import 'package:test_app/core/network/dio_network_service.dart';
import 'package:test_app/core/network/interceptor_provider.dart';
import 'package:test_app/core/network/interceptors/auth_interceptor.dart';
import 'package:test_app/core/network/network_service.dart';
import 'package:test_app/features/admin/data/datasources/admin_local_data_source.dart';
import 'package:test_app/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:test_app/features/admin/domain/interactor/admin_interactor.dart';
import 'package:test_app/features/admin/domain/repositories/admin_repository.dart';
import 'package:test_app/features/admin/domain/usecases/add_student.dart';
import 'package:test_app/features/admin/domain/usecases/delete_student.dart';
import 'package:test_app/features/admin/domain/usecases/get_admin_profile.dart';
import 'package:test_app/features/admin/domain/usecases/get_students.dart';
import 'package:test_app/features/admin/domain/usecases/get_student_by_id.dart';
import 'package:test_app/features/admin/domain/usecases/update_student.dart';
import 'package:test_app/features/admin/presentation/presenter/admin_presenter.dart';
import 'package:test_app/features/admin/presentation/router/admin_router.dart';
import 'package:test_app/features/admin/presentation/presenter/stat_generators.dart';
import 'package:test_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:test_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:test_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:test_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:test_app/features/auth/presentation/interactor/auth_interactor.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_bloc.dart';
import 'package:test_app/features/auth/presentation/router/auth_navigation.dart';
import 'package:test_app/features/auth/presentation/router/auth_router.dart';
import 'package:test_app/features/splash/presentation/presenter/splash_bloc.dart';
import 'package:test_app/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:test_app/core/services/navigation_service.dart';
import 'package:test_app/core/services/token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/features/student/domain/repositories/student_repository.dart';
import 'package:test_app/features/student/data/repositories/student_repository_impl.dart';
import 'package:test_app/features/student/domain/usecases/get_student_profile_usecase.dart';
import 'package:test_app/features/student/presentation/interactor/student_interactor.dart';
import 'package:test_app/features/student/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:test_app/core/storage/local_storage_service.dart';
import 'package:test_app/core/storage/shared_prefs_local_storage_service.dart';
import 'package:test_app/features/student/dashboard/domain/usecases/dashboard_interactor.dart';
import 'package:test_app/features/student/dashboard/presentation/presenter/student_dashboard_bloc.dart';
import 'package:test_app/features/student/dashboard/presentation/router/dashboard_router.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Core Services
  sl.registerLazySingleton(() => NavigationService());

  // Core - Storage
  sl.registerLazySingleton<LocalStorageService>(
    () => SharedPrefsLocalStorageService(sl()),
  );

  // Services
  sl.registerLazySingleton<TokenService>(() => TokenService(sl()));

  // Features - Student
  sl.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetStudentProfileUseCase>(
    () => GetStudentProfileUseCase(sl()),
  );
  sl.registerLazySingleton<StudentInteractor>(() => StudentInteractor(sl()));
  sl.registerFactory<DashboardBloc>(() => DashboardBloc(sl()));
  // Network - Interceptors
  sl.registerLazySingleton<AuthInterceptor>(() => AuthInterceptor(sl()));

  // Network - Interceptor Provider
  sl.registerLazySingleton<InterceptorProvider>(() {
    const config = AppConfig.current;
    return DefaultInterceptorProvider(
      authInterceptor: sl<AuthInterceptor>(),
      enableLogging: config.enableLogging,
      enableRetry: true,
      maxRetries: config.maxRetries,
    );
  });

  // External - Dio with Builder Pattern
  sl.registerLazySingleton<Dio>(() {
    const config = AppConfig.current;
    final interceptorProvider = sl<InterceptorProvider>();

    return DioBuilder()
        .setBaseUrl(config.apiBaseUrl)
        .setTimeouts(
          connectTimeout: config.connectTimeout,
          receiveTimeout: config.receiveTimeout,
        )
        .addInterceptors(interceptorProvider.provide())
        .build();
  });

  sl.registerLazySingleton<NetworkService>(() => DioNetworkService(sl()));

  // Features - Splash
  sl.registerFactory(() => SplashBloc(sl(), sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));

  // Features - Auth
  // Router (VIPER)
  sl.registerLazySingleton<AuthNavigation>(() => AuthRouter(sl()));

  // Bloc
  sl.registerFactory(() => AuthBloc(sl<IAuthInteractor>()));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Register IAuthInteractor with implementation
  sl.registerLazySingleton<IAuthInteractor>(
    () => AuthInteractor(sl(), sl(), sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );

  // Features - Admin
  // Dashboard Bloc
  sl.registerFactory(
    () => AdminDashboardBloc(
      profileInteractor: sl<AdminInteractor>(),
      studentReader: sl<AdminInteractor>(),
      router: sl(),
      statGenerators: [
        ActiveStudentsGenerator(),
        TotalDivisionsGenerator(),
        AvgSubjectsGenerator(),
      ],
    ),
  );

  // Student Management Bloc
  sl.registerFactory(
    () => StudentManagementBloc(
      studentReader: sl<AdminInteractor>(),
      studentWriter: sl<AdminInteractor>(),
      router: sl(),
    ),
  );

  // Interactor
  sl.registerLazySingleton<AdminInteractor>(
    () => AdminInteractorImpl(
      getAdminProfile: sl(),
      getStudents: sl(),
      getStudentById: sl(),
      addStudent: sl(),
      updateStudent: sl(),
      deleteStudent: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAdminProfile(sl()));
  sl.registerLazySingleton(() => GetStudents(sl()));
  sl.registerLazySingleton(() => GetStudentById(sl()));
  sl.registerLazySingleton(() => AddStudent(sl()));
  sl.registerLazySingleton(() => UpdateStudent(sl()));
  sl.registerLazySingleton(() => DeleteStudent(sl()));

  // Data Sources
  sl.registerLazySingleton<AdminLocalDataSource>(
    () => AdminLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<IProfileRepository>(() => sl<AdminRepository>());
  sl.registerLazySingleton<IStudentRepositoryReader>(
    () => sl<AdminRepository>(),
  );
  sl.registerLazySingleton<IStudentRepositoryWriter>(
    () => sl<AdminRepository>(),
  );

  // Features - Student Dashboard
  sl.registerFactory(() => StudentDashboardBloc(sl<IDashboardInteractor>()));
  sl.registerLazySingleton<IDashboardInteractor>(
    () => DashboardInteractor(sl()),
  );
  sl.registerLazySingleton<IDashboardRouter>(() => DashboardRouter());

  // Router
  sl.registerLazySingleton<IAdminRouter>(() => AdminRouterImpl());
}
