---
name: pub-add
description: Add a Flutter/Dart package dependency to pubspec.yaml and run pub get.
argument-hint: "<package_name> [--dev] [--version=^x.y.z]"
allowed-tools: ["Bash", "Read", "Write"]
---

Add a Flutter/Dart package to the project's `pubspec.yaml` and fetch it.

## Steps

1. Validate that a package name argument was provided. If not, ask: "Which package would you like to add?"

2. Build the `flutter pub add` command:
   - Basic: `flutter pub add <package_name>`
   - Dev dependency: `flutter pub add --dev <package_name>`
   - With version: `flutter pub add <package_name>:<version_constraint>`
   - Example: `flutter pub add http:^1.2.0`

3. Run the command:
   ```bash
   flutter pub add <package_name> 2>&1
   # or for pure Dart:
   dart pub add <package_name> 2>&1
   ```

4. If the command succeeds:
   - Show what was added to `pubspec.yaml`
   - Show the resolved version that was fetched
   - Note any transitive dependencies added

5. If the command fails (package not found, version conflict):
   - Show the error message
   - Suggest alternatives if package name looks like a typo
   - If version conflict, show the conflicting constraints and suggest resolution

6. After successful add, check if the package requires additional setup:
   - Code generation packages (`build_runner`, `freezed`, `json_serializable`): remind to run `dart run build_runner build`
   - Platform-specific packages: note any required `Info.plist` / `AndroidManifest.xml` setup
   - Packages with `flutter pub run` setup steps: mention them

7. Show a summary: "Added `<package>: <version>` to dependencies."

## Common Patterns

```bash
# Add runtime dependency
flutter pub add http

# Add dev dependency
flutter pub add --dev mockito build_runner

# Add with explicit version
flutter pub add riverpod:^2.4.0

# Add multiple packages
flutter pub add http dio
```

## Tips

- Use `flutter pub outdated` after adding to check if other packages need updates
- For packages requiring code generation, run `dart run build_runner build --delete-conflicting-outputs`
- Check pub.dev for the package's Flutter/Dart compatibility before adding
- Prefer packages with Flutter Favorite badge or high pub points
