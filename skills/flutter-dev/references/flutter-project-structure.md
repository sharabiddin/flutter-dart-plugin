# Flutter Project Structure — Conventions and Best Practices

## Standard Directory Layout

```
my_app/
├── android/                  # Android host app
├── ios/                      # iOS host app
├── linux/                    # Linux desktop (if enabled)
├── macos/                    # macOS desktop (if enabled)
├── web/                      # Web (if enabled)
├── windows/                  # Windows desktop (if enabled)
├── lib/
│   ├── main.dart             # App entry point
│   ├── app.dart              # Root widget / MaterialApp / router setup
│   └── src/                  # All application code
│       ├── features/         # Feature-first organization (recommended)
│       ├── common/           # Shared widgets, utilities, constants
│       └── core/             # App-wide setup: DI, routing, theme
├── test/
│   ├── features/             # Unit + widget tests (mirrors lib/src/features/)
│   └── helpers/              # Test utilities, fakes, fixtures
├── integration_test/         # End-to-end tests
├── assets/
│   ├── images/
│   └── fonts/
├── analysis_options.yaml     # Dart analyzer configuration
├── pubspec.yaml              # Dependencies and metadata
└── pubspec.lock              # Locked dependency versions (commit for apps)
```

## Feature-First Organization (Recommended)

Each feature is a self-contained folder:

```
lib/src/features/
├── auth/
│   ├── data/
│   │   ├── auth_repository.dart        # Abstract interface
│   │   └── auth_repository_impl.dart   # Implementation
│   ├── domain/
│   │   └── user.dart                   # Domain models
│   ├── presentation/
│   │   ├── login_page.dart
│   │   ├── login_controller.dart       # or bloc/cubit
│   │   └── widgets/
│   │       └── login_form.dart
│   └── auth.dart                       # Barrel export (optional)
├── home/
│   └── ...
└── settings/
    └── ...
```

## Common Folder Names and Their Purpose

| Folder | Contains |
|--------|----------|
| `data/` | Repository implementations, data sources, DTOs |
| `domain/` | Domain models, abstract repository interfaces, use cases |
| `presentation/` | Pages, screens, controllers, BLoC/Cubits, widgets |
| `common/` or `shared/` | Reusable widgets and utilities used across features |
| `core/` | App bootstrap: DI setup, routing, theme, constants |
| `utils/` | Pure Dart utility functions |
| `extensions/` | Dart extension methods |

## Naming Conventions

| Type | Convention | Example |
|------|-----------|---------|
| Files | `snake_case.dart` | `login_page.dart` |
| Classes | `PascalCase` | `LoginPage`, `AuthRepository` |
| Variables / functions | `camelCase` | `isLoading`, `fetchUser()` |
| Constants | `camelCase` (Dart style) | `kPrimaryColor`, `defaultTimeout` |
| Private members | `_camelCase` | `_controller`, `_buildHeader()` |
| Test files | `<subject>_test.dart` | `login_page_test.dart` |

## Barrel Exports

Barrel files (`feature.dart`) re-export public symbols, simplifying imports:

```dart
// lib/src/features/auth/auth.dart
export 'data/auth_repository.dart';
export 'domain/user.dart';
export 'presentation/login_page.dart';
```

Callers import one path instead of many:
```dart
import 'package:my_app/src/features/auth/auth.dart';
```

Use barrels selectively — they can slow down incremental compilation in large projects.

## `main.dart` vs `app.dart`

- **`main.dart`** — Entry point only: `runApp()`, environment setup, DI initialization, Firebase init, etc.
- **`app.dart`** — Root widget: `MaterialApp` / `CupertinoApp`, router, theme, localization delegates.

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: App()));
}

// app.dart
class App extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      theme: AppTheme.light,
    );
  }
}
```

## Assets Configuration

Declare assets in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/          # All files in directory
    - assets/images/logo.png  # Specific file
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
```

Access in code:
```dart
Image.asset('assets/images/logo.png')
```

## `analysis_options.yaml` Baseline

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  errors:
    invalid_annotation_target: ignore  # For freezed

linter:
  rules:
    prefer_const_constructors: true
    prefer_final_fields: true
    avoid_print: true
    use_key_in_widget_constructors: false  # Disable if using go_router
```

## `.gitignore` for Flutter Projects

```gitignore
# Flutter/Dart
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
build/

# Platform
ios/Pods/
ios/.symlinks/
android/.gradle/
android/local.properties

# Local settings
.env
.claude/*.local.md
```

Commit `pubspec.lock` for **apps** (reproducible builds). Do **not** commit it for **packages** (let consumers resolve).
