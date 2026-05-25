import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/dio_client.dart';
import '../config/app_config.dart';

// Data sources
import 'package:desktop_system/data/datasources/remote/auth_remote_datasource.dart';
import 'package:desktop_system/data/datasources/remote/system_remote_datasource.dart';
import 'package:desktop_system/data/datasources/remote/order_remote_datasource.dart';
import 'package:desktop_system/core/services/dict_service.dart';
import 'package:desktop_system/data/datasources/local/storage_datasource.dart';

// Repositories (using domain interfaces)
import 'package:desktop_system/domain/repositories/auth_repository.dart';
import 'package:desktop_system/domain/repositories/order_repository.dart';
import 'package:desktop_system/domain/repositories/dict_repository.dart';
import 'package:desktop_system/data/repositories/dict_repository_impl.dart';
import 'package:desktop_system/data/repositories/auth_repository_impl.dart';
import 'package:desktop_system/data/repositories/order_repository_impl.dart';

// BLoCs
import 'package:desktop_system/features/splash/bloc/splash_bloc.dart';
import 'package:desktop_system/features/auth/bloc/auth_bloc.dart';
import 'package:desktop_system/features/order/bloc/order_bloc.dart';

// Use Cases
import 'package:desktop_system/domain/usecases/usecases.dart';
import 'package:desktop_system/domain/usecases/order_usecase.dart';

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
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<SystemRemoteDataSource>(
    () => SystemRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<DictRepository>(
    () => DictRepositoryImpl(remoteDataSource: getIt<SystemRemoteDataSource>()),
  );
  getIt.registerLazySingleton<DictService>(
    () => DictService(getIt<DictRepository>()),
  );
  getIt.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSource(getIt<DioClient>()),
  );

  // ========== Repositories ==========
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      storageDataSource: getIt<StorageDataSource>(),
    ),
  );

  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      remoteDataSource: getIt<OrderRemoteDataSource>(),
    ),
  );

  // ========== Use Cases ==========
  getIt.registerLazySingleton<AuthUseCase>(
    () => AuthUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<OrderUsecase>(
    () => OrderUsecase(getIt<OrderRepository>()),
  );

  // ========== BLoCs ==========
  getIt.registerFactory<SplashBloc>(() => SplashBloc());

  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(authUseCase: getIt<AuthUseCase>()),
  );

  getIt.registerFactory<OrderBloc>(
    () => OrderBloc(orderUsecase: getIt<OrderUsecase>()),
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
