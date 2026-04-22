import 'package:flutter/material.dart';

import 'core/config/app_config.dart';
import 'core/di/setup_dependencies.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 获取环境变量，默认为dev环境
  const env = String.fromEnvironment('ENV', defaultValue: 'dev');

  // 加载环境配置
  await AppConfig.load(env);

  // 初始化依赖
  await setupDependencies();


  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const App();
  }
}
