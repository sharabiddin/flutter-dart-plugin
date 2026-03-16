---
name: analyze
description: Run dart analyze or flutter analyze on the current project and surface all diagnostics (errors, warnings, lints) for Claude to review and fix.
argument-hint: "[--fix] [path]"
allowed-tools: ["Bash", "Read", "Grep"]
---

Run `flutter analyze` (or `dart analyze` for non-Flutter projects) on the current project. Surface all diagnostics so they can be reviewed and fixed.

## Steps

1. Detect whether the project is Flutter or Dart by checking if `pubspec.yaml` contains `sdk: flutter` or running `flutter --version` to verify Flutter is available:
   ```bash
   grep -q "sdk: flutter" pubspec.yaml 2>/dev/null && echo "flutter" || echo "dart"
   ```

2. Run the analyzer:
   ```bash
   # Flutter project:
   flutter analyze 2>&1

   # Pure Dart project:
   dart analyze 2>&1
   ```

3. Parse the output:
   - Count errors, warnings, and infos
   - Group by file
   - Identify the most critical issues first

4. If `--fix` argument was provided, also run:
   ```bash
   dart fix --apply 2>&1
   ```
   Then re-run analysis to show remaining issues after auto-fix.

5. If `path` argument was provided, analyze only that path:
   ```bash
   dart analyze <path> 2>&1
   ```

6. Report findings to the user:
   - Summary line: `X errors, Y warnings, Z infos`
   - List each error with file:line, message, and diagnostic code
   - Suggest fixes for common patterns (see dart-diagnostics skill)
   - Ask if the user wants to fix issues automatically or manually

## Tips

- If `flutter analyze` is not found, fall back to `dart analyze`
- If there are no issues, report "✓ No diagnostics found"
- Errors must be fixed for the project to compile; prioritize them
- Check `analysis_options.yaml` if unexpected rules are triggering
