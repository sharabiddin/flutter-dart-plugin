# flutter-dart

A Claude Code plugin for Flutter/Dart developers. Surfaces diagnostics, fixes lint issues, manages dependencies, and runs tests — all via the native `dart`/`flutter` CLI.

## Features

- **Auto-diagnostics** — After editing `.dart` files, `dart analyze` runs automatically and errors/warnings are fed back to Claude
- **`/flutter-dart:analyze`** — Run full project analysis and surface all issues
- **`/flutter-dart:fix`** — Apply `dart fix` auto-fixes with preview
- **`/flutter-dart:test`** — Run tests and analyze failures
- **`/flutter-dart:pub-add`** — Add packages to pubspec.yaml
- **`/flutter-dart:pub-upgrade`** — Check outdated packages and upgrade
- **`dart-fixer` agent** — Autonomously fixes all dart analyzer errors across a project
- **`flutter-test-analyst` agent** — Runs tests, diagnoses failures, writes new tests

## Prerequisites

- Flutter SDK or Dart SDK installed and in `PATH`
- `jq` installed (used by the auto-analyze hook): `brew install jq`

## Installation

```bash
# Test locally
cc --plugin-dir /path/to/flutter-dart-plugin

# Or copy to your project's Claude plugins folder
cp -r /path/to/flutter-dart-plugin ~/.claude/plugins/flutter-dart
```

## Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/flutter-dart:analyze` | Run analyzer, show all diagnostics | `/flutter-dart:analyze --fix` |
| `/flutter-dart:fix` | Auto-fix lint issues with preview | `/flutter-dart:fix --code=unused_import` |
| `/flutter-dart:test` | Run tests, analyze failures | `/flutter-dart:test test/login_test.dart` |
| `/flutter-dart:pub-add` | Add a package | `/flutter-dart:pub-add http --dev` |
| `/flutter-dart:pub-upgrade` | Upgrade packages | `/flutter-dart:pub-upgrade --major` |

## Agents

| Agent | Trigger |
|-------|---------|
| `dart-fixer` | "Fix all dart errors", "make dart analyze pass" |
| `flutter-test-analyst` | "Run tests and fix failures", "why are my tests failing" |

## Skills (Auto-activated)

- **Dart Diagnostics** — Activates when working with dart analyzer output, error codes, lint rules
- **Flutter Development** — Activates when managing pubspec.yaml, packages, flutter CLI commands

## Auto-Analyze Hook

After editing any `.dart` file, the plugin automatically runs `dart analyze` / `flutter analyze`. If errors or warnings are found, they are fed back to Claude as context so it can fix them immediately.

To **disable** the auto-analyze hook, add this to `.claude/flutter-dart.local.md`:

```markdown
---
auto_analyze: false
---
```

## Settings (`.claude/flutter-dart.local.md`)

Create this file in your project to configure plugin behavior:

```markdown
---
flutter_path: /custom/path/to/flutter   # Default: flutter (from PATH)
dart_path: /custom/path/to/dart         # Default: dart (from PATH)
auto_analyze: true                       # Run analyze after .dart edits (default: true)
analyze_flags: "--fatal-infos"           # Extra flags for dart analyze
test_flags: "--coverage"                 # Extra flags for flutter test
---

Any notes about this Flutter project go here.
```

Add `.claude/*.local.md` to your `.gitignore` to keep settings local.
