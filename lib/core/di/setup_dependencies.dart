import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/storage_service.dart';
import '../../services/api_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/ticket_repository.dart';
import '../../data/repositories/ticket_repository_impl.dart';
import '../../data/repositories/svg_repository.dart';
import '../../data/repositories/svg_repository_impl.dart';
import '../../features/splash/presentation/bloc/splash_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  getIt.registerSingleton<StorageService>(
    StorageService(getIt<SharedPreferences>()),
  );

  getIt.registerSingleton<ApiService>(ApiService());

  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(getIt<StorageService>(), getIt<ApiService>()),
  );

  getIt.registerSingleton<TicketRepository>(TicketRepositoryImpl());

  getIt.registerSingleton<SvgRepository>(SvgRepositoryImpl());

  getIt.registerFactory<SplashBloc>(() => SplashBloc());

  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));
}
