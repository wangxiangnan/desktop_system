import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/dio_client.dart';
import '../config/app_config.dart';

// Data sources
import '../../data/datasources/remote/ticket_remote_datasource.dart';
import '../../data/datasources/remote/svg_remote_datasource.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/local/ticket_local_datasource.dart';
import '../../data/datasources/local/svg_local_datasource.dart';
import '../../data/datasources/local/storage_datasource.dart';

// Repositories (using domain interfaces)
import '../../domain/repositories/ticket_repository.dart';
import '../../domain/repositories/svg_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/ticket_repository_impl.dart';
import '../../data/repositories/svg_repository_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';

// BLoCs
import '../../features/splash/bloc/splash_bloc.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/tickets/bloc/ticket_bloc.dart';
import '../../features/svg/bloc/svg_bloc.dart';

// Auth Use Cases
import '../../domain/usecases/usecases.dart';

final GetIt getIt = GetIt.instance;

/// Initialize all dependencies
Future<void> setupDependencies() async {
  // ========== Core ==========
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Dio client (singleton)
  getIt.registerSingleton<DioClient>(DioClient());
  getIt.registerLazySingleton<StorageDataSource>(
    () => StorageDataSource(getIt<SharedPreferences>()),
  );
  DioClient().setStorageDataSource(getIt<StorageDataSource>());

  // ========== Data Sources ==========

  // Remote data sources
  getIt.registerLazySingleton<TicketRemoteDataSource>(
    () => TicketRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<SvgRemoteDataSource>(
    () => SvgRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<DioClient>()),
  );

  // Local data sources
  getIt.registerLazySingleton<TicketLocalDataSource>(
    () => TicketLocalDataSource(),
  );
  getIt.registerLazySingleton<SvgLocalDataSource>(
    () => SvgLocalDataSource(),
  );

  // ========== Repositories ==========
  getIt.registerLazySingleton<TicketRepository>(
    () => TicketRepositoryImpl.fromConfig(
      remoteDataSource: getIt<TicketRemoteDataSource>(),
      localDataSource: getIt<TicketLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<SvgRepository>(
    () => SvgRepositoryImpl.fromConfig(
      remoteDataSource: getIt<SvgRemoteDataSource>(),
      localDataSource: getIt<SvgLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      storageDataSource: getIt<StorageDataSource>(),
    ),
  );

  // ========== Auth Use Cases ==========
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<GetCaptchaUseCase>(
    () => GetCaptchaUseCase(getIt<AuthRepository>()),
  );

  // ========== BLoCs ==========
  getIt.registerFactory<SplashBloc>(() => SplashBloc());

  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
      getCaptchaUseCase: getIt<GetCaptchaUseCase>(),
    ),
  );

  getIt.registerFactory<TicketBloc>(
    () => TicketBloc(getIt<TicketRepository>()),
  );

  getIt.registerFactory<SvgBloc>(
    () => SvgBloc(getIt<SvgRepository>()),
  );

  // Log configuration
  if (AppConfig.debugMode) {
    print('=== Dependency Injection Config ===');
    print('Environment: ${AppConfig.environment}');
    print('Use Mock Data: ${AppConfig.useMockData}');
    print('API Base URL: ${AppConfig.apiBaseUrl}');
    print('===================================');
  }
}
