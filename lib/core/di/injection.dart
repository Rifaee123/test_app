import 'package:get_it/get_it.dart';
import 'package:test_app/core/config/app_config.dart';
import 'package:test_app/core/network/dio_builder.dart';
import 'package:test_app/core/network/dio_network_service.dart';
import 'package:test_app/core/network/interceptor_provider.dart';
import 'package:test_app/core/network/interceptors/auth_interceptor.dart';
import 'package:test_app/core/network/network_service.dart';
import 'package:test_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:test_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:test_app/features/auth/domain/usecases/auth_interactor.dart';
import 'package:test_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:test_app/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:test_app/features/admin/domain/repositories/admin_repository.dart';
import 'package:test_app/features/admin/domain/interactor/admin_interactor.dart';
import 'package:test_app/features/admin/domain/usecases/add_student.dart';
import 'package:test_app/features/admin/domain/usecases/get_admin_profile.dart';
import 'package:test_app/features/admin/domain/usecases/get_students.dart';
import 'package:test_app/features/admin/domain/usecases/update_student.dart';
import 'package:test_app/features/admin/domain/usecases/delete_student.dart';
import 'package:test_app/features/admin/presentation/presenter/admin_presenter.dart';
import 'package:test_app/features/admin/presentation/router/admin_router.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
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
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  // Features - Admin
  // Presenter
  sl.registerFactory(
    () => AdminPresenter(
      profileInteractor: sl<AdminInteractor>(),
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
      addStudent: sl(),
      updateStudent: sl(),
      deleteStudent: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAdminProfile(sl()));
  sl.registerLazySingleton(() => GetStudents(sl()));
  sl.registerLazySingleton(() => AddStudent(sl()));
  sl.registerLazySingleton(() => UpdateStudent(sl()));
  sl.registerLazySingleton(() => DeleteStudent(sl()));

  // Repository
  sl.registerLazySingleton<AdminRepository>(() => AdminRepositoryImpl());

  // Router
  sl.registerLazySingleton<IAdminRouter>(() => AdminRouterImpl());
}
