---
name: flutter-dev
description: This skill should be used when the user asks to "add a flutter package", "add dependency", "update pubspec", "upgrade packages", "run flutter pub get", "pub upgrade", "what package should I use for X", "flutter pub add", "add to pubspec.yaml", "check for package updates", or when working with `pubspec.yaml`, managing Flutter/Dart project dependencies, or asking about recommended packages. Also activates when running Flutter tests, build commands, or common Flutter CLI operations.
version: 0.1.0
---

# Flutter Development

Provides expert guidance on Flutter/Dart project management: dependency management via `pubspec.yaml`, the `pub` CLI, running tests, build commands, and common Flutter workflow operations.

## pubspec.yaml Structure

```yaml
name: my_app
description: A Flutter application.
version: 1.0.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"
  flutter: ">=3.10.0"

dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0         # Caret: compatible with 1.x.x
  riverpod: ">=2.0.0"  # Range constraint
  my_local_pkg:
    path: ../my_local_pkg  # Local path dependency

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
  fonts:
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf
```

## Dependency Management Commands

### Adding Packages

```bash
# Add a dependency
flutter pub add package_name

# Add a dev dependency
flutter pub add --dev package_name

# Add with version constraint
flutter pub add package_name:^2.0.0

# Add multiple at once
flutter pub add http riverpod flutter_hooks
```

### Fetching Dependencies

```bash
flutter pub get       # Fetch all dependencies
dart pub get          # Same for pure Dart projects
```

### Upgrading

```bash
flutter pub upgrade                  # Upgrade to latest allowed by constraints
flutter pub upgrade --major-versions  # Also upgrade major versions (updates pubspec)
flutter pub outdated                  # Show which packages have newer versions
```

### Removing Packages

```bash
flutter pub remove package_name
```

### Inspecting Dependencies

```bash
flutter pub deps                      # Show dependency tree
flutter pub deps --style=compact      # Compact view
dart pub publish --dry-run            # Check if package is publishable
```

## Common Flutter Packages by Category

### State Management
- `riverpod` / `flutter_riverpod` — Modern, compile-safe state management
- `bloc` / `flutter_bloc` — BLoC pattern
- `provider` — Simple inherited widget wrapper

### Navigation
- `go_router` — Declarative routing (recommended by Flutter team)
- `auto_route` — Code-generated routing with deep links

### Networking
- `http` — Simple HTTP client
- `dio` — Feature-rich HTTP client (interceptors, FormData)
- `retrofit` — Type-safe REST client (code generation)

### Local Storage
- `shared_preferences` — Key-value storage
- `hive` / `isar` — Fast local NoSQL database
- `sqflite` — SQLite for Flutter
- `drift` — Type-safe SQLite ORM

### Code Generation
- `freezed` — Immutable data classes, unions
- `json_serializable` — JSON serialization
- `build_runner` — Code generation runner

### Testing
- `mockito` / `mocktail` — Mocking for unit tests
- `golden_toolkit` — Screenshot (golden) testing

### UI
- `cached_network_image` — Network images with cache
- `shimmer` — Loading placeholder effect
- `flutter_svg` — SVG rendering
- `lottie` — Lottie animations

## Running Tests

```bash
# Run all tests
flutter test

# Run a specific test file
flutter test test/widget_test.dart

# Run tests matching a name pattern
flutter test --name "login"

# Run with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Run integration tests
flutter test integration_test/

# Run with verbose output
flutter test --reporter expanded
```

Test output interpretation:
- `✓` — Test passed
- `✗` or `FAILED` — Test failed (shows stack trace)
- `SKIPPED` — Test skipped with `skip:` parameter

## Build Commands

```bash
# Run in debug mode
flutter run

# Run on specific device
flutter run -d chrome
flutter run -d emulator-5554

# Build release APK (Android)
flutter build apk --release

# Build release App Bundle (Android, for Play Store)
flutter build appbundle --release

# Build iOS release (macOS only)
flutter build ios --release

# Build for web
flutter build web

# Build macOS desktop
flutter build macos --release
```

## Code Generation

Many packages (freezed, json_serializable, riverpod_generator) require code generation:

```bash
# Run once
dart run build_runner build

# Watch for changes and regenerate
dart run build_runner watch

# Delete conflicting outputs first
dart run build_runner build --delete-conflicting-outputs
```

## Version Constraint Guide

| Constraint | Meaning |
|-----------|---------|
| `^1.2.3` | `>=1.2.3 <2.0.0` (caret, most common) |
| `>=1.0.0 <2.0.0` | Explicit range |
| `any` | Any version (avoid in published packages) |
| `1.2.3` | Exact version (pinned) |

Use caret (`^`) for most dependencies. Use exact pins only when a specific version is required.

## Checking pub.dev

To find the best package for a use case, check:
- Search at pub.dev
- Prefer packages with Flutter Favorite badge or high pub points
- Check: `sdk: flutter` compatibility, maintenance score, latest version date

## Additional Resources

- **`references/flutter-project-structure.md`** — Recommended project structure and conventions
- **`references/testing-patterns.md`** — Unit, widget, and integration test patterns
