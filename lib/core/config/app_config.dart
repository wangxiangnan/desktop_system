import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();

  factory AppConfig() {
    return _instance;
  }

  AppConfig._internal();

  /// 加载环境配置文件
  ///
  /// [env] 环境名称：dev, test, staging, prod
  /// 先加载通用基础配置(.env)，再加载环境特定配置(.env.xxx)
  static Future<void> load(String env) async {
    // 先加载基础配置
    await dotenv.load(fileName: '.env');
    // 合并环境特定配置（会覆盖基础配置中的相同项）
    await dotenv.load(fileName: '.env.$env', mergeWith: dotenv.env);
  }

  /// 获取环境变量
  ///
  /// [key] 环境变量键名
  /// [defaultValue] 默认值（可选）
  static String? get(String key, {String? defaultValue}) {
    return dotenv.env[key] ?? defaultValue;
  }

  /// 获取环境变量（带默认值）
  ///
  /// [key] 环境变量键名
  /// [defaultValue] 默认值
  static String getString(String key, String defaultValue) {
    return dotenv.env[key] ?? defaultValue;
  }

  /// 获取布尔值环境变量
  ///
  /// [key] 环境变量键名
  /// [defaultValue] 默认值
  static bool getBool(String key, bool defaultValue) {
    final value = dotenv.env[key];
    if (value == null) return defaultValue;
    return value.toLowerCase() == 'true';
  }

  /// 获取整数值环境变量
  ///
  /// [key] 环境变量键名
  /// [defaultValue] 默认值
  static int getInt(String key, int defaultValue) {
    final value = dotenv.env[key];
    if (value == null) return defaultValue;
    return int.tryParse(value) ?? defaultValue;
  }

  /// 获取应用名称
  static String get appName => getString('APP_NAME', 'Desktop System');

  /// 获取API基础URL
  static String get apiBaseUrl =>
      getString('API_BASE_URL', 'https://api.example.com');

  /// 获取调试模式
  static bool get debugMode => getBool('DEBUG_MODE', false);

  /// 获取日志级别
  static String get logLevel => getString('LOG_LEVEL', 'info');

  /// 获取环境名称
  static String get environment => getString('ENVIRONMENT', 'production');

  /// 是否使用模拟数据（开发/测试时绕过API）
  static bool get useMockData => getBool('USE_MOCK_DATA', false);

  /// 是否为开发环境
  static bool get isDevelopment => environment == 'development';

  /// 是否为测试环境
  static bool get isTest => environment == 'test';

  /// 是否为灰度环境
  static bool get isStaging => environment == 'staging';

  /// 是否为生产环境
  static bool get isProduction => environment == 'production';

  /// 获取连接超时时间（毫秒）
  static int get connectTimeout => getInt('CONNECT_TIMEOUT', 30000);

  /// 获取接收超时时间（毫秒）
  static int get receiveTimeout => getInt('RECEIVE_TIMEOUT', 30000);

  /// 获取所有环境变量（用于调试）
  static Map<String, String> get allVars => dotenv.env;
}
