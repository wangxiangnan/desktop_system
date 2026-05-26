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
- `lib/core/services/print_service.dart`: General-purpose print service (SVG, images, PDF)
- `lib/core/models/print_content.dart`: Sealed content model for print payloads
- `lib/features/print_preview/pages/print_preview_page.dart`: Print preview page with PdfPreview

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

## Print System

The print system consists of a content model, a print service, a settings service for persistent configuration, a preview page, and a settings page.

### Key Files

- `lib/core/models/print_content.dart`: Sealed content model (image file/url/bytes, SVG, PDF)
- `lib/core/models/print_settings.dart`: Data model for printer selection, page format, orientation, margins, job name, and direct-print mode. Serializes to/from SharedPreferences via `fromPrefs`/`saveToPrefs`.
- `lib/core/services/print_service.dart`: Generates PDF from PrintContent, supports optional PrintSettings for page format/margins. `printDirectly()` routes to `Printing.directPrintPdf()` when settings have directPrint enabled + printer selected, otherwise falls back to `Printing.layoutPdf()` (system dialog).
- `lib/core/services/print_settings_service.dart`: Loads/saves PrintSettings from SharedPreferences, lists available printers via `Printing.listPrinters()`.
- `lib/features/print_preview/pages/print_preview_page.dart`: Preview page. Shows a settings summary bar (format, orientation, margins, printer). When `directPrint` is enabled and a printer is selected, the built-in system-dialog print button is hidden and replaced with a custom direct-print button that sends the PDF directly to the printer with a "打印中..." loading dialog, success/failure SnackBar, and auto-navigates back on success. Uses `ValueKey(_previewKey)` on PdfPreview to force re-render when settings change.
- `lib/features/settings/pages/print_settings_page.dart`: Full settings form — printer dropdown (loaded from system), direct-print toggle, page format dropdown (A4/A3/Letter/Legal), orientation segmented button, margin fields (mm), job name, save/reset buttons.

### PrintContent Types

| Factory | Input | Use Case |
|---------|-------|----------|
| `PrintContent.imageFile(path)` | Local file path | Print local image files |
| `PrintContent.imageUrl(url)` | HTTP URL | Print remote images |
| `PrintContent.imageBytes(bytes)` | `Uint8List` | Print in-memory image data |
| `PrintContent.svg(svgString)` | SVG markup string | Print SVG content (rasterized to PNG) |
| `PrintContent.pdf(builder:)` | Async callback | Print custom-generated PDF |

### PrintSettings Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `pageFormatName` | String | `'a4'` | One of: a4, a3, letter, legal |
| `isLandscape` | bool | `false` | Page orientation |
| `marginLeft/Top/Right/Bottom` | double | `10.0` | Margins in mm |
| `jobName` | String | `'Print Job'` | Print task name shown in system dialog |
| `directPrint` | bool | `false` | Skip system dialog, send directly to printer |
| `selectedPrinterUrl` | String? | `null` | Platform-specific printer identifier |
| `selectedPrinterName` | String? | `null` | Display name of selected printer |

### Usage

```dart
// Navigate to preview page
final content = PrintContent.svg(svgString, title: 'My SVG');
getIt<PrintService>().navigateToPreview(context, content);

// Direct print with custom settings
final settings = getIt<PrintSettingsService>().loadSettings();
await getIt<PrintService>().printDirectly(content, settings: settings);

// For PdfContent builders: always load settings to respect user preferences
final settings = getIt<PrintSettingsService>().loadSettings();
doc.addPage(pw.MultiPage(pageFormat: settings.pageFormat, ...));
```

### Routes

- `/print-preview`: Preview page. Content passed via GoRouter `extra` as `PrintContent`.
- `/print-settings`: Settings page (static). Accessible from sidebar and home dashboard.
