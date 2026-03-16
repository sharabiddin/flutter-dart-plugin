---
name: fix
description: Apply dart fix to auto-fix lint issues and diagnostics in the current project. Shows a preview first, then applies fixes.
argument-hint: "[--code=<diagnostic_code>] [--dry-run]"
allowed-tools: ["Bash", "Read"]
---

Apply `dart fix` to automatically fix lint issues and diagnostics in the current project.

## Steps

1. First, show a preview of what would be fixed:
   ```bash
   dart fix --dry-run 2>&1
   ```

2. Parse the dry-run output to count and list the changes:
   - Show how many files would be changed
   - Show which diagnostic codes would be fixed
   - Show the count of changes per code

3. If `--dry-run` argument was provided, stop here and report the preview.

4. If `--code=<diagnostic_code>` argument was provided, apply only that specific fix:
   ```bash
   dart fix --apply --code=<diagnostic_code> 2>&1
   ```

5. Otherwise, ask the user to confirm before applying all fixes:
   "Found X auto-fixable issues. Apply all fixes? (yes/no)"

6. On confirmation (or if no issues found that need confirmation), apply:
   ```bash
   dart fix --apply 2>&1
   ```

7. After applying, run analysis again to show remaining issues:
   ```bash
   flutter analyze 2>&1
   # or: dart analyze 2>&1
   ```

8. Report:
   - How many issues were fixed
   - How many remain (and why they can't be auto-fixed)
   - Suggestions for fixing remaining issues manually

## Common Auto-Fixable Issues

- `unused_import` — removes unused imports
- `prefer_const_constructors` — adds `const`
- `unnecessary_this` — removes `this.`
- `prefer_final_fields` — adds `final`
- `always_declare_return_types` — adds return types
- `sort_child_properties_last` — reorders widget props

## Tips

- `dart fix` only fixes issues that have a registered fix; not all lint rules have one
- Some fixes may introduce new diagnostics (e.g., adding `const` may cascade)
- Always re-run `flutter analyze` after fixing to confirm the result
- For manual fixes, refer to the dart-diagnostics skill for code-specific guidance
