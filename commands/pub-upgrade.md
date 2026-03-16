---
description: Show outdated Flutter/Dart packages and upgrade them, with control over which packages to upgrade.
argument-hint: "[--major] [<package_name>]"
allowed-tools: ["Bash", "Read", "Write"]
---

Show outdated packages and upgrade Flutter/Dart dependencies.

## Steps

1. First, show what's outdated:
   ```bash
   flutter pub outdated 2>&1
   # or: dart pub outdated 2>&1
   ```

2. Parse the outdated output — columns are:
   - Package name
   - Current (resolved version)
   - Upgradable (latest within current constraints)
   - Latest (absolute latest including breaking changes)
   - Null safety status

3. If a specific `<package_name>` argument was provided:
   - Show only that package's status
   - Upgrade only that package: `flutter pub upgrade <package_name>`

4. If `--major` argument was provided, upgrade including major versions:
   ```bash
   flutter pub upgrade --major-versions 2>&1
   ```
   This also updates version constraints in `pubspec.yaml`.

5. Otherwise, upgrade within current constraints (safe, no breaking changes):
   ```bash
   flutter pub upgrade 2>&1
   ```

6. After upgrade, show:
   - Which packages were upgraded (old → new versions)
   - Which packages have newer major versions available but were not upgraded (require `--major`)
   - Whether `pubspec.lock` was updated

7. If `--major` was used, show a diff of `pubspec.yaml` changes to version constraints.

8. Recommend running tests after upgrade:
   - "Run `/flutter-dart:test` to verify nothing broke after upgrading."

## Tips

- Prefer upgrading without `--major` first to minimize risk
- After `--major` upgrade, check each package's changelog for breaking changes
- `pubspec.lock` should be committed in app projects (not library packages) to pin exact versions
- If upgrade causes analyzer errors, run `/flutter-dart:analyze` to see what broke
- Upgrading `flutter_lints` may introduce new lint warnings — run `/flutter-dart:fix` after
