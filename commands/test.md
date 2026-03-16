---
description: Run Flutter/Dart tests and surface results, failures, and stack traces so Claude can analyze and fix them.
argument-hint: "[test/path/file_test.dart] [--name=<pattern>] [--coverage]"
allowed-tools: ["Bash", "Read", "Grep"]
---

Run `flutter test` (or `dart test` for pure Dart) on the current project and surface results for analysis.

## Steps

1. Determine the test command based on project type:
   ```bash
   grep -q "sdk: flutter" pubspec.yaml 2>/dev/null && echo "flutter test" || echo "dart test"
   ```

2. Build the test command from arguments:
   - If a file path argument was given: `flutter test <path>`
   - If `--name=<pattern>`: `flutter test --name="<pattern>"`
   - If `--coverage`: `flutter test --coverage`
   - Default (no args): `flutter test`

3. Run tests with expanded reporter for readable output:
   ```bash
   flutter test --reporter expanded 2>&1
   ```

4. Parse the results:
   - Total tests run
   - Passed count
   - Failed count
   - Skipped count
   - Total time

5. For each failing test, extract and show:
   - Test name and file location
   - Failure message
   - Stack trace (trimmed to relevant frames)
   - Expected vs actual values if assertion failure

6. If `--coverage` was used, report:
   ```bash
   # After flutter test --coverage:
   genhtml coverage/lcov.info -o coverage/html 2>&1 || true
   ```
   Show overall line coverage percentage.

7. Summarize and offer next steps:
   - If all pass: "✓ All X tests passed"
   - If failures: analyze root cause, suggest fixes, ask if user wants fixes applied

## Tips

- Run specific failing test file to get faster feedback during fixing
- `--reporter expanded` gives readable output vs default dot reporter
- Stack traces in Flutter point to framework code deep in the stack; look for the first frame in `lib/` or `test/` as the actual source
- Widget test failures often show widget tree diffs — read them top-down to find the first mismatch
- If tests time out, check for missing `pumpAndSettle()` or async issues in widget tests
- Integration tests live in `integration_test/` and require a device/emulator
