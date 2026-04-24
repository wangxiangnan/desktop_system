# AGENTS.md - Development Guide for desktop_system

## Build, Lint, and Test Commands

### Flutter Commands
```bash
# Run the application
flutter run

# Build for Windows desktop
flutter build windows

# Build for macOS
flutter build macos

# Build for Linux
flutter build linux

# Run the Flutter analyzer (lint)
flutter analyze

# Fix analyzer issues automatically
flutter analyze --fix
```

### Testing Commands
```bash
# Run all tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Run tests matching a specific name
flutter test --name "test_name_pattern"

# Run tests with verbose output
flutter test --reporter=expanded
```

### Code Generation
```bash
# Generate code (e.g., for freezed, json_serializable)
dart run build_runner build

# Watch mode for code generation
dart run build_runner watch

# Delete generated code and rebuild
dart run build_runner build --delete-conflicting-outputs
```

---

## Code Style Guidelines

### General Principles
- Follow the Dart style guide: https://dart.dev/guides/language/effective-dart
- Use the `flutter_lints` ruleset (included in analysis_options.yaml)
- Keep lines under 80 characters when practical
- Use meaningful, descriptive names

### Naming Conventions

#### Files
- Use snake_case: `ticket_list_page.dart`, `auth_service.dart`
- Prefix test files with `test_`: `test_ticket_service.dart`

#### Classes, Enums, Typedefs
- Use PascalCase: `class TicketController`, `enum TicketStatus`
- Suffix with type: `TicketModel`, `TicketController`, `TicketView`

#### Variables, Functions, Methods
- Use camelCase: `final ticketList`, `void fetchTickets()`
- Private members with underscore: `bool _isLoading`

#### Constants
- Use camelCase for constant variables: `const maxRetries = 3`
- Use UPPER_SNAKE_CASE for compile-time constants: `static const int maxAge = 100`

### Imports

#### Order (dart organize imports)
1. Dart SDK imports
2. Package imports (`package:flutter/...`)
3. Relative imports (other files in this package)

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ticket_model.dart';
import '../../core/constants/app_colors.dart';
```

#### Import Path Rules

| 引用范围 | 导入方式 | 示例 |
|---------|---------|------|
| 同一模块内的文件 | 相对路径 | `../entities/user_entity.dart` |
| 跨模块引用（一级模块外） | package 路径 | `package:desktop_system/core/constants/app_colors.dart` |

```dart
// Good - 同一 domain 模块内，使用相对路径
import '../entities/user_entity.dart';

// Good - features 引用 core，使用 package 路径
import 'package:desktop_system/core/constants/app_colors.dart';

// Bad - 跨模块却用相对路径（避免多层 ../..）
import '../../core/constants/app_colors.dart';
```

一级模块包括：`app`, `core`, `data`, `domain`, `features`, `routing`, `services`, `shared`

- Use relative imports for files within the same package
- Avoid `export` files unless creating a public API
- Group imports with blank lines between groups

### Type Annotations

#### Function Parameters and Return Types
```dart
// Good
void submitForm(String name, int age) {
  // ...
}

// Bad - avoid implicit types
void submitForm(name, age) {
  // ...
}
```

#### Variables
```dart
// Good - explicit types for public API and complex types
final List<TicketModel> tickets = [];
final TicketController controller = TicketController();

// Optional - can omit for simple local variables
var count = 0;
final name = 'John';
```

#### Async/Await
```dart
// Good
Future<TicketModel> fetchTicket(String id) async {
  final response = await api.get('/tickets/$id');
  return TicketModel.fromJson(response.data);
}
```

### Formatting

#### Braces
```dart
// Use trailing brace style
if (condition) {
  doSomething();
} else {
  doOtherThing();
}

// Single line body - still use braces
if (condition) {
  doSomething();
}
```

#### Spacing
- Use 2 spaces for indentation
- No trailing whitespace
- No more than one consecutive empty line

```dart
// Good
class TicketCard extends StatelessWidget {
  final TicketModel ticket;

  const TicketCard({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(ticket.title),
      ),
    );
  }
}
```

### Error Handling

#### Try-Catch
```dart
// Good - specific exception types
try {
  final result = await fetchTickets();
} on NetworkException catch (e) {
  // Handle network error
  showErrorDialog('Network error: ${e.message}');
} on ServerException catch (e) {
  // Handle server error
  showErrorDialog('Server error: ${e.message}');
} catch (e) {
  // Catch-all for unexpected errors
  showErrorDialog('An unexpected error occurred');
}
```

#### Null Safety
```dart
// Good - use null safety operators
String? name;
final displayName = name ?? 'Unknown';

final items = list.where((item) => item != null).toList();

// Use late for lazy initialization
late final SharedPreferences prefs;
```

### BLoC Guidelines

#### State Design
- Use a single state class instead of multiple state classes (e.g., `AuthState`)
- Include all state properties in one class with nullable types
- Use status enum or flags to distinguish states

```dart
// Good - single state class
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final CaptchaData? captcha;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.captcha,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    CaptchaData? captcha,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      captcha: captcha ?? this.captcha,
    );
  }
}

enum AuthStatus { initial, loading, success, failure }

// Bad - multiple state classes
// class AuthLoading {}
// class AuthSuccess { user }
// class AuthFailure { error }
```

#### Event Design
- Use sealed classes or simple events for better pattern matching
- Keep events focused and single-purpose

### Widget Guidelines

#### Build Methods
```dart
// Good - break down into smaller widgets
Widget build(BuildContext context) {
  return Column(
    children: [
      _buildHeader(),
      _buildContent(),
      _buildFooter(),
    ],
  );
}

Widget _buildHeader() {
  return Text('Header');
}
```

#### Context Usage
```dart
// Avoid storing BuildContext
void _onTap(BuildContext context) {
  // Good - use context directly
  final theme = Theme.of(context);
  
  // Bad - don't do this
  _savedContext = context;
}
```

### Performance Considerations

- Use `const` constructors where possible
- Use `RepaintBoundary` for expensive widgets
- Use `ListView.builder` for large lists
- Avoid rebuilding widgets unnecessarily with `const` children
- Use `AutomaticKeepAliveClientMixin` for tab views

---

## Project Structure

```
lib/
├── main.dart
├── app/                 # App configuration
├── core/               # Constants, theme, utilities
├── data/               # Models, repositories, providers
├── features/           # Feature modules (auth, tickets, home, settings)
├── routing/            # Router configuration
├── services/           # Services (auth, permission, print, storage)
└── shared/            # Shared widgets and common pages
```

---

## Testing Guidelines

### Unit Tests
- Test business logic in isolation
- Mock external dependencies
- Use descriptive test names

```dart
void main() {
  group('TicketModel', () {
    test('fromJson creates valid model', () {
      final json = {'id': '1', 'title': 'Test Ticket'};
      final ticket = TicketModel.fromJson(json);
      
      expect(ticket.id, '1');
      expect(ticket.title, 'Test Ticket');
    });
  });
}
```

### Widget Tests
- Test widget rendering
- Test user interactions
- Verify state changes

---

## Common Issues and Solutions

### Circular Imports
- Avoid importing files that import you
- Use a shared module (e.g., `core/`) for cross-feature dependencies

### Memory Leaks
- Dispose controllers and subscriptions
- Use `AutomaticDisposeMixin` from riverpod when applicable
