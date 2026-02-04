import 'package:get_it/get_it.dart';
import 'package:test_app/core/config/app_config.dart';
import 'package:test_app/core/network/dio_builder.dart';
import 'package:test_app/core/network/dio_network_service.dart';
import 'package:test_app/core/network/interceptor_provider.dart';
import 'package:test_app/core/network/interceptors/auth_interceptor.dart';
import 'package:test_app/core/network/network_service.dart';
import 'package:test_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:test_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:test_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:test_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:test_app/features/auth/presentation/interactor/auth_interactor.dart';
import 'package:test_app/features/auth/presentation/presenter/auth_bloc.dart';
import 'package:test_app/features/auth/presentation/router/auth_navigation.dart';
import 'package:test_app/features/auth/presentation/router/auth_router.dart';
import 'package:test_app/core/services/navigation_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/core/storage/local_storage_service.dart';
import 'package:test_app/core/storage/shared_prefs_local_storage_service.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  // External - Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Core - Storage
  sl.registerLazySingleton<LocalStorageService>(
    () => SharedPrefsLocalStorageService(sl()),
  );

  // Features - Auth
  // Router (VIPER)
  sl.registerLazySingleton<AuthNavigation>(() => AuthRouter(sl()));

  // Bloc
  sl.registerFactory(() => AuthBloc(sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => AuthInteractor(sl(), sl(), sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );

  // Services
  sl.registerLazySingleton<NetworkService>(() => DioNetworkService(sl()));
  sl.registerLazySingleton(() => NavigationService());

  // Network - Interceptors
  sl.registerLazySingleton(() => AuthInterceptor(sl()));

  // Network - Interceptor Provider
  sl.registerLazySingleton<InterceptorProvider>(() {
    final config = AppConfig.current;
    return DefaultInterceptorProvider(
      authInterceptor: sl<AuthInterceptor>(),
      enableLogging: config.enableLogging,
      enableRetry: true,
      maxRetries: config.maxRetries,
    );
  });

  // External - Dio with Builder Pattern
  sl.registerLazySingleton(() {
    final config = AppConfig.current;
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
}
