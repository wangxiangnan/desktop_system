import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/dio_client.dart';
import '../config/app_config.dart';

// Data sources
import 'package:desktop_system/data/datasources/remote/ticket_remote_datasource.dart';
import 'package:desktop_system/data/datasources/remote/svg_remote_datasource.dart';
import 'package:desktop_system/data/datasources/remote/auth_remote_datasource.dart';
import 'package:desktop_system/data/datasources/remote/system_remote_datasource.dart';
import 'package:desktop_system/data/datasources/remote/order_remote_datasource.dart';
import 'package:desktop_system/data/datasources/local/ticket_local_datasource.dart';
import 'package:desktop_system/data/datasources/local/svg_local_datasource.dart';
import 'package:desktop_system/data/datasources/local/storage_datasource.dart';

// Repositories (using domain interfaces)
import 'package:desktop_system/domain/repositories/ticket_repository.dart';
import 'package:desktop_system/domain/repositories/svg_repository.dart';
import 'package:desktop_system/domain/repositories/auth_repository.dart';
import 'package:desktop_system/domain/repositories/order_repository.dart';
import 'package:desktop_system/data/repositories/ticket_repository_impl.dart';
import 'package:desktop_system/data/repositories/svg_repository_impl.dart';
import 'package:desktop_system/data/repositories/auth_repository_impl.dart';
import 'package:desktop_system/data/repositories/order_repository_impl.dart';

// BLoCs
import 'package:desktop_system/features/splash/bloc/splash_bloc.dart';
import 'package:desktop_system/features/auth/bloc/auth_bloc.dart';
import 'package:desktop_system/features/ticket/bloc/ticket_bloc.dart';
import 'package:desktop_system/features/svg/bloc/svg_bloc.dart';
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
  getIt.registerLazySingleton<TicketRemoteDataSource>(
    () => TicketRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<SvgRemoteDataSource>(
    () => SvgRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<SystemRemoteDataSource>(
    () => SystemRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSource(getIt<DioClient>()),
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

  getIt.registerFactory<TicketBloc>(
    () => TicketBloc(getIt<TicketRepository>()),
  );

  getIt.registerFactory<SvgBloc>(
    () => SvgBloc(getIt<SvgRepository>()),
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
