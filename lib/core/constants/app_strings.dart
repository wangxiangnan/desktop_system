import '../config/app_config.dart';

class AppStrings {
  AppStrings._();

  static String get appName => AppConfig.appName;
  static String logoUrl = 'assets/images/logo.png';

  // Splash
  static const String splashTitle = '桌面管理系统启动页-展示新功能';
  static const String skip = 'Skip >>';

  // Login
  static const String login = '登录';
  static const String username = '用户名';
  static const String password = '密码';
  static const String loginButton = '登 录';
  static const String loginWelcome = '👏 Hi，欢迎登录～';
  static const String captcha = '验证码';
  static const String captchaRequired = '请输入验证码';
  static const String captchaHint = '点击验证码图片可刷新';
  static const String usernameRequired = '请输入用户名';
  static const String passwordRequired = '请输入密码';

  // Common
  static const String loading = '加载中...';
  static const String error = '错误';
  static const String retry = '重试';
  static const String cancel = '取消';
  static const String ok = '确定';
  static const String save = '保存';
  static const String printing = '打印中...';
  static const String user = 'User';
  static const String dashboard = 'Dashboard';
  static const String settings = 'Settings';
  static const String appSettings = 'App settings';

  // Home
  static const String orderManagement = '订单管理';
  static const String orderManagementDesc = '查看和管理订单';
  static const String printSettings = '打印设置';
  static const String printSettingsDesc = '配置打印页面和边距';

  // Network errors
  static const String errorSessionExpired = '登录已过期，请重新登录';
  static const String errorForbidden = '没有权限访问该资源';
  static const String errorNotFound = '请求的资源不存在';
  static const String errorServerError = '服务器内部错误';
  static const String errorTimeout = '网络连接超时，请检查网络';
  static const String errorConnection = '网络连接失败，请检查网络';
  static const String errorRequestFailed = '请求失败';
  static const String errorNetworkFailed = '网络请求失败';

  // Footer
  static const String recordNumber = '京ICP备2022030824号-1';
  static const String internetFilingNumber = '京公网安备11010502059128号';
}
