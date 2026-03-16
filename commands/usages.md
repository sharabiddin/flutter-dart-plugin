---
description: Find all usages of a Dart class, method, or function using LSP for semantically accurate results — distinguishes between symbols with the same name in different classes.
argument-hint: "<SymbolName>"
allowed-tools: ["Read", "Bash"]
---

Find all usages of a Dart symbol using the Language Server Protocol (LSP) for accurate, semantic results. Unlike text search, LSP understands the code structure and won't confuse two different `build()` methods from different classes.

## Steps

1. Validate a symbol name was provided. If not, ask: "Which class or function would you like to find usages for?"

2. **Check LSP availability**: Attempt a `workspaceSymbol` LSP call for the symbol name using any `.dart` file in the project as the anchor. If the LSP tool is unavailable or returns an error indicating no language server is running, immediately fall back to `/flutter-dart:find-refs <SymbolName>` and stop — do not proceed with the steps below.

3. **Locate the symbol** using `workspaceSymbol`:
   - Call LSP `workspaceSymbol` with the symbol name, using any `.dart` file in the project as `filePath` (e.g. the first file found under `lib/`).
   - If multiple matches are returned, list them and ask the user to pick one — show each with its container name and file path.
   - If no match is found, tell the user and suggest checking the spelling or whether the symbol is defined in a dependency package (not project source).

4. **Find all references** using `findReferences`:
   - Use the `filePath`, `line`, and `character` from the symbol location returned in step 3.
   - Call LSP `findReferences` at that position.

5. **Optionally enrich results** based on symbol kind:
   - If the symbol is an **abstract class or interface**: also call `goToImplementation` to list all concrete implementations.
   - If the symbol is a **method or function**: also call `incomingCalls` to show the call hierarchy (who calls this, and who calls them).

6. **Read each referenced file** to extract the surrounding line of code for display (use `Read` with a narrow range around the reported line number).

7. **Group and display results** by file:
   ```
   Found X usages of `SymbolName` across Y files:

   lib/src/features/auth/login_page.dart (2 usages)
     line 14  LoginBloc bloc = LoginBloc();
     line 38  context.read<LoginBloc>().add(LoginSubmitted());

   test/features/auth/login_bloc_test.dart (4 usages)
     line  9  final bloc = LoginBloc();
     line 22  bloc.add(LoginSubmitted());
     ...
   ```

8. **If `goToImplementation` was called**, append an "Implementations" section:
   ```
   Implementations of `SymbolName`:
     lib/src/repositories/user_repository_impl.dart — line 12
   ```

9. **If `incomingCalls` was called**, append a "Called by" section showing the direct callers.

10. **If 0 usages found**:
    - Note that LSP only indexes files open or recently parsed by the language server — large projects may need the server to finish indexing.
    - Suggest running `/flutter-dart:find-refs <SymbolName>` as a text-search fallback.
    - Check if the symbol is exported-only (used by external packages, not in project source).

## Notes

- LSP results are **semantically accurate**: two methods named `build()` in different widgets are treated as different symbols.
- The language server must be running and have indexed the file. If you get an LSP error, wait a moment and retry, or open the file in the IDE to trigger indexing.
- For symbols defined in dependencies (not your source), LSP may return the definition inside the `.dart_tool/` cache — that is expected.
- Combine with `/flutter-dart:find-refs` on the returned implementations for full coverage of polymorphic call sites.
