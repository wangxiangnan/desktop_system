import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/dio_client.dart';
import '../../services/storage_service.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/ticket_service.dart';
import '../../services/svg_service.dart';
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

  // 注册Dio客户端
  getIt.registerSingleton<DioClient>(DioClient());

  // 注册服务
  getIt.registerSingleton<AuthService>(AuthService(getIt<DioClient>()));
  getIt.registerSingleton<TicketService>(TicketService(getIt<DioClient>()));
  getIt.registerSingleton<SvgService>(SvgService(getIt<DioClient>()));

  // 保持向后兼容的ApiService
  getIt.registerSingleton<ApiService>(ApiService());

  // 注册仓库
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(getIt<StorageService>(), getIt<AuthService>()),
  );

  getIt.registerSingleton<TicketRepository>(
    TicketRepositoryImpl(ticketService: getIt<TicketService>()),
  );

  getIt.registerSingleton<SvgRepository>(
    SvgRepositoryImpl(svgService: getIt<SvgService>()),
  );

  getIt.registerFactory<SplashBloc>(() => SplashBloc());

  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));
}
