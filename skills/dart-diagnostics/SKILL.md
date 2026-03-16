---
name: Dart Diagnostics
description: This skill should be used when the user asks to "analyze dart code", "fix dart errors", "run dart analyze", "explain dart warning", "fix lint issues", "apply dart fix", "why is dart complaining about", "dart diagnostic", or when Claude encounters dart analyzer output, error codes like `dart_error`, `invalid_return_type`, `unused_import`, or linter violations. Activates automatically when working with `.dart` files that have errors or warnings.
version: 0.1.0
---

# Dart Diagnostics

Provides expert interpretation of Dart/Flutter analyzer output, error codes, and linter violations. Use this skill to read, explain, and fix diagnostics surfaced by `dart analyze` or the Dart language server.

## Running the Analyzer

To get current diagnostics for a project:

```bash
dart analyze
# or for Flutter projects:
flutter analyze
```

For a single file:
```bash
dart analyze lib/src/my_file.dart
```

Output format:
```
Analyzing project...
  error   • The method 'foo' isn't defined   lib/src/file.dart:12:5   • undefined_method
  warning • Unused import 'dart:io'           lib/src/file.dart:1:1    • unused_import
  info    • Prefer const constructors         lib/src/file.dart:20:14  • prefer_const_constructors
```

Each line has: severity · message · file:line:column · diagnostic_code

## Severity Levels

| Severity | Meaning | Action Required |
|----------|---------|-----------------|
| `error` | Code will not compile or has undefined behavior | Must fix |
| `warning` | Likely bug or bad practice | Should fix |
| `info` / `lint` | Style or optional improvement | Consider fixing |

## Applying Auto-Fixes

Many diagnostics have machine-applicable fixes:

```bash
dart fix --apply
```

To preview what would change without applying:
```bash
dart fix --dry-run
```

To fix a specific diagnostic only:
```bash
dart fix --apply --code=unused_import
```

## Common Error Codes and Fixes

### Type Errors

- **`invalid_assignment`** — Value assigned to incompatible type. Explicit cast needed or fix the type.
- **`invalid_return_type`** — Return type of function doesn't match declaration. Update return type or returned value.
- **`argument_type_not_assignable`** — Wrong type passed to parameter. Use correct type or cast with `as`.
- **`null_check_always_fails`** — Null check (`!`) on value that's never null; remove the `!`.
- **`unchecked_use_of_nullable_value`** — Accessing member on nullable without null check. Use `?.`, `!`, or null check first.

### Undefined References

- **`undefined_method`** — Method doesn't exist on the type. Check spelling, check imports, check if method is on correct class.
- **`undefined_identifier`** — Variable/class not in scope. Check imports or declare the identifier.
- **`undefined_named_parameter`** — Named parameter not in function signature. Check function definition.
- **`uri_does_not_exist`** — Import path wrong. Verify file path or package name in `pubspec.yaml`.

### Null Safety

- **`non_nullable_equals_null`** — Non-nullable variable compared to null; always false.
- **`unnecessary_null_comparison`** — Null comparison on non-nullable; remove.
- **`prefer_null_aware_operators`** — Use `?.` instead of `if (x != null) x.method()`.

### Lint Rules (Common)

- **`prefer_const_constructors`** — Add `const` before constructor call.
- **`avoid_print`** — Replace `print()` with proper logging (`developer.log` or a logger).
- **`unused_import`** — Remove the import.
- **`unnecessary_this`** — Remove `this.` prefix.
- **`prefer_final_fields`** — Mark field as `final`.
- **`always_declare_return_types`** — Add explicit return type to function.

## Interpreting `dart analyze` JSON Output

When running in CI or parsing programmatically:

```bash
dart analyze --format json 2>&1
```

Output structure:
```json
{
  "version": 1,
  "diagnostics": [
    {
      "code": "unused_import",
      "severity": "WARNING",
      "message": "Unused import: 'dart:io'",
      "location": {
        "file": "lib/src/file.dart",
        "range": { "start": { "line": 1, "column": 1 }, "end": { "line": 1, "column": 15 } }
      }
    }
  ]
}
```

## Analysis Options Configuration

Dart analysis is configured in `analysis_options.yaml` at project root:

```yaml
include: package:flutter_lints/flutter.yaml  # or dart/recommended

analyzer:
  errors:
    unused_import: error      # Upgrade to error
    dead_code: ignore         # Suppress
  exclude:
    - "**/*.g.dart"           # Exclude generated files
    - "**/*.freezed.dart"

linter:
  rules:
    prefer_const_constructors: true
    avoid_print: true
    always_declare_return_types: false  # Disable a rule
```

Common rule sets to include:
- `package:lints/recommended.yaml` — Dart recommended
- `package:flutter_lints/flutter.yaml` — Flutter recommended
- `package:very_good_analysis/analysis_options.yaml` — Strict

## Fixing Diagnostics Workflow

1. Run `dart analyze` to get current diagnostics
2. Group errors by type (type errors first, then warnings, then lints)
3. Run `dart fix --apply` to auto-fix what's possible
4. Re-run `dart analyze` to see remaining issues
5. Fix remaining errors manually, starting with `error` severity
6. Run `dart analyze` once more to confirm clean

## Additional Resources

- **`references/error-codes.md`** — Extended list of diagnostic codes and fix strategies
- **`references/null-safety.md`** — Null safety migration and patterns
