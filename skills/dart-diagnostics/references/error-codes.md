# Dart Diagnostic Error Codes — Extended Reference

A comprehensive reference of Dart analyzer error codes, their causes, and fix strategies.

## Type System Errors

| Code | Message | Fix |
|------|---------|-----|
| `invalid_assignment` | A value of type X can't be assigned to a variable of type Y | Cast with `as Y` or fix the source type |
| `invalid_return_type_for_catch_error` | Return type doesn't match onError callback | Align return types |
| `argument_type_not_assignable` | The argument type X can't be assigned to parameter type Y | Use correct type or cast |
| `return_of_invalid_type` | A value of type X can't be returned from a function with return type Y | Fix return type or value |
| `invalid_cast_new_expr` | The constructor returns type X, not Y | Check class hierarchy |
| `type_test_with_undefined_name` | The name X isn't a type | Import the type or fix the name |

## Null Safety Errors

| Code | Message | Fix |
|------|---------|-----|
| `unchecked_use_of_nullable_value` | An expression of type X? must be null-checked | Use `!`, `?.`, or a null check |
| `null_check_always_fails` | Null check on a value that can never be null | Remove the `!` |
| `non_nullable_equals_null` | Non-nullable can't equal null | Remove the comparison |
| `unnecessary_null_comparison` | Comparison is always true/false because X is non-nullable | Remove the check |
| `invalid_null_aware_operator` | Receiver can't be null, so `?.` is unnecessary | Replace `?.` with `.` |
| `nullable_type_in_catch_clause` | A nullable type can't be used in a catch clause | Use non-nullable type |

## Undefined / Scope Errors

| Code | Message | Fix |
|------|---------|-----|
| `undefined_method` | The method X isn't defined for type Y | Check spelling, imports, or correct type |
| `undefined_identifier` | Undefined name X | Import the library or declare the variable |
| `undefined_named_parameter` | The named parameter X isn't defined | Check function signature |
| `undefined_getter` | The getter X isn't defined for type Y | Check property name and type |
| `undefined_setter` | The setter X isn't defined for type Y | Check property name and if it's writable |
| `undefined_class` | Undefined class X | Add the import |
| `undefined_extension` | The extension X isn't defined | Import the extension's library |
| `uri_does_not_exist` | Target of URI doesn't exist | Verify path and package name in `pubspec.yaml` |
| `uri_has_not_been_generated` | Target of URI hasn't been generated | Run `dart run build_runner build` |

## Const / Final Errors

| Code | Message | Fix |
|------|---------|-----|
| `not_constant_expression` | Expression is not a compile-time constant | Use a const value or move to runtime |
| `const_initialized_with_non_constant_value` | A const variable must be initialized with a constant value | Remove `const` or use a constant expression |
| `assignment_to_final` | The final variable X can't be assigned a value | Remove `final` or use a new variable |
| `assignment_to_const` | Constant variables can't be assigned a value | Use a non-const variable |

## Async / Await Errors

| Code | Message | Fix |
|------|---------|-----|
| `await_only_futures` | `await` applied to non-Future | Remove `await` or return a Future |
| `missing_return` | This function has a return type but has no return | Add a return statement |
| `body_might_complete_normally` | The body might complete normally | Add a return, throw, or exhaustive handling |

## Import / Export Errors

| Code | Message | Fix |
|------|---------|-----|
| `duplicate_import` | Duplicate import | Remove one of the imports |
| `unused_import` | Unused import | Remove the import |
| `unused_shown_name` | Shown name X is not used | Remove X from the `show` clause |
| `hidden_name_shown` | Name X is both hidden and shown | Fix the import directives |
| `ambiguous_import` | The name X is defined in multiple libraries | Use a prefix: `import '...' as foo` |

## Common Lint Rule Codes

| Code | Fix |
|------|-----|
| `prefer_const_constructors` | Add `const` before the constructor call |
| `prefer_const_literals_to_create_immutables` | Use `const []` / `const {}` |
| `avoid_print` | Replace with `developer.log()` or a logger |
| `prefer_final_fields` | Mark field as `final` |
| `prefer_final_locals` | Mark local variable as `final` |
| `unnecessary_this` | Remove `this.` prefix |
| `always_declare_return_types` | Add explicit return type |
| `unnecessary_new` | Remove `new` keyword |
| `unnecessary_const` | Remove redundant `const` |
| `annotate_overrides` | Add `@override` annotation |
| `use_key_in_widget_constructors` | Add `Key? key` parameter to widget constructor |
| `sized_box_for_whitespace` | Replace `Container(width: X, height: Y)` with `SizedBox` |
| `avoid_unnecessary_containers` | Remove unnecessary `Container` wrapper |

## Getting the Full List

```bash
# Show all available lint rules
dart analyze --list-lint-rules

# Show all diagnostic codes (Dart SDK source)
# https://github.com/dart-lang/sdk/tree/main/pkg/analyzer/lib/src/error/codes.dart
```
