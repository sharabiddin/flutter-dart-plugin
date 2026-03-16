#!/usr/bin/env bash
# dart-analyze-on-edit.sh
# After editing a .dart file, run dart analyze and surface diagnostics to Claude.
# Exits 0 (no output) for non-.dart files. Exits 2 with stderr on analyzer errors.
set -euo pipefail

# Read hook input from stdin
input=$(cat)

# Extract the file path from tool input
file_path=$(echo "$input" | jq -r '.tool_input.file_path // .tool_input.path // ""' 2>/dev/null || true)

# Only run for .dart files
if [[ -z "$file_path" ]] || [[ "$file_path" != *.dart ]]; then
  exit 0
fi

# Only run if we're inside a Dart/Flutter project (has pubspec.yaml)
project_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"
if [[ ! -f "$project_dir/pubspec.yaml" ]]; then
  exit 0
fi

# Determine dart or flutter
if grep -q "sdk: flutter" "$project_dir/pubspec.yaml" 2>/dev/null; then
  ANALYZE_CMD="flutter analyze"
else
  ANALYZE_CMD="dart analyze"
fi

# Run analyzer, capture output
cd "$project_dir"
analyze_output=$($ANALYZE_CMD 2>&1) || true
exit_code=$?

# If no issues, silently exit
if echo "$analyze_output" | grep -q "No issues found!"; then
  exit 0
fi

# Count issues
error_count=$(echo "$analyze_output" | grep -c "^\s*error\s" || echo "0")
warning_count=$(echo "$analyze_output" | grep -c "^\s*warning\s" || echo "0")
info_count=$(echo "$analyze_output" | grep -c "^\s*info\s" || echo "0")

# If there are errors or warnings, feed back to Claude via stderr (exit 2)
if [[ "$error_count" -gt 0 ]] || [[ "$warning_count" -gt 0 ]]; then
  echo "dart analyze found issues after editing $file_path:" >&2
  echo "" >&2
  echo "$analyze_output" >&2
  echo "" >&2
  echo "Summary: $error_count errors, $warning_count warnings, $info_count infos" >&2
  exit 2
fi

# Only infos — show as stdout (non-blocking)
if [[ "$info_count" -gt 0 ]]; then
  echo "dart analyze: $info_count info/lint issue(s) in project (no errors or warnings)"
fi

exit 0
