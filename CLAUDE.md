# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter desktop application with multi-environment support (dev, test, staging, prod). The app uses:
- Flutter Bloc for state management
- Dependency injection (get_it)
- Multi-environment configuration via `.env` files
- Routing via `AppRouter`

## Key Files

- `lib/app/app.dart`: Main application entry point with splash screen and auth flow
- `lib/core/config/app_config.dart`: Environment configuration loader
- `lib/routing/app_router.dart`: Application routing configuration
- `lib/features/auth/bloc/`: Authentication state management

## Build & Run Commands

### Development
```bash
flutter run --dart-define=ENV=dev
```

### Testing
```bash
flutter run --dart-define=ENV=test
```

### Production
```bash
flutter run --dart-define=ENV=prod
```

### Build Targets
```bash
# Windows
flutter build windows --dart-define=ENV=<env>

# macOS
flutter build macos --dart-define=ENV=<env>

# Linux
flutter build linux --dart-define=ENV=<env>
```

## Environment Configuration

- Configuration is loaded from `.env` (base) and `.env.<env>` (environment-specific)
- Access config values via `AppConfig` class
- Never commit sensitive values in `.env.<env>` files

## Architecture

The app follows a layered architecture:
1. **Presentation Layer**: UI components and pages
2. **Business Logic**: Blocs for state management
3. **Data Layer**: Repositories and services
4. **Core**: Configuration, routing, and utilities

When modifying the app:
- Add new features under `lib/features/<feature>`
- Keep business logic in Blocs
- Use dependency injection for services
