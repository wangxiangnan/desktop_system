# 多环境构建说明

## 环境配置文件

项目支持以下环境配置文件：
- `.env` - 通用基础配置（所有环境共享）
- `.env.dev` - 开发环境特定配置
- `.env.test` - 测试环境特定配置
- `.env.staging` - 灰度环境特定配置
- `.env.prod` - 生产环境特定配置

### 配置加载顺序
1. 先加载 `.env` 基础配置
2. 再加载对应环境的 `.env.xxx` 配置（会覆盖基础配置中的相同项）

### 配置文件说明
- **基础配置（.env）**：包含所有环境通用的配置项，如功能开关、超时配置、分页配置等
- **环境配置（.env.xxx）**：包含环境特定的配置项，如API地址、调试模式、日志级别等

## 构建命令

### 开发环境
```bash
# 运行开发环境
flutter run --dart-define=ENV=dev

# 构建Windows桌面应用（开发环境）
flutter build windows --dart-define=ENV=dev

# 构建macOS应用（开发环境）
flutter build macos --dart-define=ENV=dev

# 构建Linux应用（开发环境）
flutter build linux --dart-define=ENV=dev
```

### 测试环境
```bash
# 运行测试环境
flutter run --dart-define=ENV=test

# 构建Windows桌面应用（测试环境）
flutter build windows --dart-define=ENV=test

# 构建macOS应用（测试环境）
flutter build macos --dart-define=ENV=test

# 构建Linux应用（测试环境）
flutter build linux --dart-define=ENV=test
```

### 灰度环境
```bash
# 运行灰度环境
flutter run --dart-define=ENV=staging

# 构建Windows桌面应用（灰度环境）
flutter build windows --dart-define=ENV=staging

# 构建macOS应用（灰度环境）
flutter build macos --dart-define=ENV=staging

# 构建Linux应用（灰度环境）
flutter build linux --dart-define=ENV=staging
```

### 生产环境
```bash
# 运行生产环境
flutter run --dart-define=ENV=prod

# 构建Windows桌面应用（生产环境）
flutter build windows --dart-define=ENV=prod

# 构建macOS应用（生产环境）
flutter build macos --dart-define=ENV=prod

# 构建Linux应用（生产环境）
flutter build linux --dart-define=ENV=prod
```

## 在代码中使用环境配置

```dart
import 'core/config/app_config.dart';

// 获取配置值
final apiBaseUrl = AppConfig.apiBaseUrl;
final appName = AppConfig.appName;
final debugMode = AppConfig.debugMode;

// 检查环境
if (AppConfig.isDevelopment) {
  // 开发环境特定逻辑
}

if (AppConfig.isProduction) {
  // 生产环境特定逻辑
}

// 获取自定义环境变量
final customValue = AppConfig.getString('CUSTOM_KEY', 'default_value');
```

## 添加新的环境变量

### 通用配置（所有环境共享）
1. 在 `.env` 文件中添加新的变量
2. 在 `AppConfig` 类中添加对应的 getter 方法
3. 使用 `AppConfig.get()` 或 `AppConfig.getString()` 获取值

### 环境特定配置
1. 在对应的 `.env.xxx` 文件中添加新的变量（会覆盖基础配置中的同名变量）
2. 在 `AppConfig` 类中添加对应的 getter 方法
3. 使用 `AppConfig.get()` 或 `AppConfig.getString()` 获取值

### 示例
```bash
# .env（基础配置）
API_TIMEOUT=30000
MAX_FILE_SIZE=10485760

# .env.dev（开发环境覆盖）
API_TIMEOUT=60000  # 开发环境使用更长的超时时间

# .env.prod（生产环境）
API_TIMEOUT=15000  # 生产环境使用更短的超时时间
```

## 注意事项

1. 环境变量在应用启动时加载，不能在运行时更改
2. 敏感信息（如API密钥）不应提交到版本控制系统
3. 建议将 `.env.*` 文件添加到 `.gitignore` 中，或使用 `.env.example` 作为模板
4. 通用配置 `.env` 文件可以提交到版本控制系统（不包含敏感信息）
5. 环境特定配置 `.env.xxx` 文件建议添加到 `.gitignore`，或使用 `.env.xxx.example` 作为模板

## 配置文件结构示例

```
├── .env                    # 通用基础配置（可提交）
├── .env.dev.example        # 开发环境配置模板（可提交）
├── .env.dev                # 开发环境配置（不提交）
├── .env.test.example       # 测试环境配置模板（可提交）
├── .env.test               # 测试环境配置（不提交）
├── .env.staging.example    # 灰度环境配置模板（可提交）
├── .env.staging            # 灰度环境配置（不提交）
├── .env.prod.example       # 生产环境配置模板（可提交）
└── .env.prod               # 生产环境配置（不提交）
```