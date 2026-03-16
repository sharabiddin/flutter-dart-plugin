---
description: Find all references (usages) of a Dart symbol — method, class, variable, or parameter — across the project's .dart files. Similar to "Find References" in an IDE.
argument-hint: "<SymbolName>"
allowed-tools: ["Bash", "Read"]
---

Find all usages of a Dart symbol across the project's `.dart` files. Works like IDE "Find References" using ripgrep for fast, accurate results.

## Steps

1. Validate a symbol name was provided. If not, ask: "Which symbol would you like to find references for?"

2. Run ripgrep across all `.dart` files (excluding generated files):
   ```bash
   rg --word-regexp --with-filename --line-number --context 2 \
     --glob "*.dart" \
     --glob "!**/*.g.dart" \
     --glob "!**/*.freezed.dart" \
     --glob "!**/*.gen.dart" \
     "<SymbolName>" \
     lib/ test/ 2>/dev/null
   ```
   If `rg` is not available, fall back to:
   ```bash
   grep -rn --include="*.dart" \
     --exclude="*.g.dart" --exclude="*.freezed.dart" \
     -w "<SymbolName>" lib/ test/
   ```

3. Parse and group results by file. For each file show:
   - File path (relative to project root)
   - Each matching line with line number
   - 2 lines of context around each match
   - Count of references in that file

4. Categorize each reference type where possible:
   - **Definition** — `class SymbolName`, `void symbolName(`, `final symbolName =`
   - **Call site** — `symbolName(`, `.symbolName(`
   - **Import** — `import '...symbolName...'`
   - **Type usage** — `SymbolName variable`, `List<SymbolName>`
   - **Override** — `@override` above the match

5. Report summary:
   ```
   Found X references to `SymbolName` across Y files:

   lib/src/features/auth/... (3 references)
     line 41  — [call site]   await GamesServices.signIn()
     line 52  — [call site]   final id = await GamesServices.getPlayerID()
     line 101 — [call site]   await GamesServices.fetchIdentityVerificationSignature()

   test/... (1 reference)
     line 22  — [call site]   when(() => mock.symbolName()).thenAnswer(...)
   ```

6. If 0 references found:
   - Check if the symbol exists anywhere (without word boundary): try without `--word-regexp`
   - Suggest checking spelling or whether the symbol is in a package (not project source)
   - Note that generated files were excluded if that might be relevant

7. If the symbol appears to be **unused** (only definition, no call sites), flag it:
   - "⚠️ `SymbolName` is defined but has no call sites in lib/ or test/ — it may be unused."

## Tips

- Symbol search is case-sensitive — use exact casing (`LoginBloc` not `loginbloc`)
- For method names that are common words, add the class prefix: search `GamesServices.fetchIdentity` instead of just `fetchIdentity`
- Generated files (`.g.dart`, `.freezed.dart`) are excluded by default to reduce noise — add `--no-ignore` to include them if needed
- To find where a class is **instantiated** specifically, search for `SymbolName(` (with parenthesis)
