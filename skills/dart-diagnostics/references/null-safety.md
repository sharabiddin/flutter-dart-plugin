# Dart Null Safety — Patterns and Migration Reference

## Core Concepts

Dart's sound null safety (introduced in Dart 2.12) makes `null` a first-class concern at compile time. A type `T` is non-nullable by default; `T?` is nullable.

```dart
String name = 'Alice';   // Non-nullable: can never be null
String? nickname;        // Nullable: can be null
```

## Null-Aware Operators

| Operator | Name | Meaning |
|----------|------|---------|
| `?.` | Null-aware access | `a?.b` — returns null if `a` is null, else `a.b` |
| `??` | If-null | `a ?? b` — returns `a` if non-null, else `b` |
| `??=` | Null-aware assignment | `a ??= b` — assigns `b` to `a` only if `a` is null |
| `!` | Null assertion | `a!` — asserts `a` is non-null at runtime (throws if null) |
| `?..` | Null-aware cascade | `a?..foo()..bar()` — skips cascade if `a` is null |
| `?[]` | Null-aware index | `a?[0]` — returns null if `a` is null |

## Common Patterns

### Null Check Before Use
```dart
// Bad
String? name;
print(name.length); // Error: unchecked_use_of_nullable_value

// Good — guard check
if (name != null) {
  print(name.length); // Promoted to non-nullable inside block
}

// Good — null-aware
print(name?.length ?? 0);
```

### Null Assertion (`!`)
```dart
String? value = getValue();
// Use only when you're certain it's not null:
String definite = value!; // throws StateError if null
```

Avoid overusing `!`. Prefer null-aware operators or guard checks.

### Late Initialization
```dart
// For values set after declaration but before use
late String userId;

void init() {
  userId = fetchUserId(); // Must be called before userId is accessed
}
```

Use `late` sparingly — prefer constructor initialization or nullable types.

### Required Named Parameters
```dart
// Pre-null safety: named params were optional by default
// Post-null safety: use `required` for non-nullable named params
class Widget {
  Widget({required String title, String? subtitle});
}
```

### Nullable Return Types
```dart
// Returning null to signal absence
User? findUser(String id) {
  return _users.firstWhereOrNull((u) => u.id == id);
}

// Caller handles null
final user = findUser('123');
if (user == null) return;
print(user.name); // promoted
```

## Null Safety Migration Patterns

### Pattern 1 — Add `?` where null is intentional
```dart
// Before
String email; // implicitly nullable in old code

// After
String? email; // explicitly nullable
```

### Pattern 2 — Add `!` for values you know are non-null
```dart
// Before
String name = map['name']; // was dynamic

// After
String name = map['name']!; // assert non-null
// or safer:
String name = map['name'] as String? ?? '';
```

### Pattern 3 — Use `required` for non-nullable constructor params
```dart
// Before
MyClass({String title}) : title = title ?? '';

// After
MyClass({required String title});
```

### Pattern 4 — Replace null guards with promoted types
```dart
// Old style
if (obj != null) {
  return obj.value; // obj still typed as T? in old Dart
}

// New — type promotion works automatically
if (obj != null) {
  return obj.value; // obj is T (non-nullable) inside block
}
```

## Working with Collections

```dart
// Nullable list
List<String>? items;
final count = items?.length ?? 0;
final first = items?.first; // String?

// Non-nullable list with nullable items
List<String?> items = ['a', null, 'b'];
final nonNull = items.whereType<String>().toList(); // [a, b]

// Filter nulls
List<String?> raw = fetchData();
List<String> clean = raw.whereType<String>().toList();
// or
List<String> clean = raw.nonNulls.toList(); // Dart 3.0+
```

## Async and Null Safety

```dart
// Nullable future
Future<String?> loadName() async => null;

// Handle nullable result
final name = await loadName();
if (name == null) return;
print(name.toUpperCase()); // promoted

// With default
final name = await loadName() ?? 'Anonymous';
```

## Freezed / Data Classes

```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    String? avatarUrl, // Optional field
  }) = _User;
}
```

## Migrating Legacy Code

```bash
# Run the migration tool (Dart 2.12+)
dart migrate

# Apply suggested changes interactively in browser
dart migrate --apply-changes
```

After migration, audit all `!` usages — the tool adds them conservatively; some may be replaceable with safer patterns.
