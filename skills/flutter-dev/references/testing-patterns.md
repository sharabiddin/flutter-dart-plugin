# Flutter Testing Patterns — Unit, Widget, and Integration

## Test Types Overview

| Type | What it tests | Speed | Tool |
|------|--------------|-------|------|
| Unit | Pure Dart logic, repositories, BLoCs | Fast | `dart test` / `flutter test` |
| Widget | Single widget rendering and interaction | Medium | `flutter test` + `WidgetTester` |
| Integration | Full app flows on a real device/emulator | Slow | `flutter test integration_test/` |

## Unit Tests

### Basic Structure

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthRepository', () {
    late AuthRepository repository;

    setUp(() {
      repository = AuthRepository();
    });

    tearDown(() {
      repository.dispose();
    });

    test('returns user on successful login', () async {
      final user = await repository.login('user@example.com', 'password');
      expect(user.email, equals('user@example.com'));
    });

    test('throws AuthException on wrong password', () async {
      expect(
        () => repository.login('user@example.com', 'wrong'),
        throwsA(isA<AuthException>()),
      );
    });
  });
}
```

### Mocking with Mocktail

```dart
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;
  late LoginController controller;

  setUp(() {
    mockRepo = MockAuthRepository();
    controller = LoginController(repository: mockRepo);
  });

  test('emits loading then success', () async {
    when(() => mockRepo.login(any(), any()))
        .thenAnswer((_) async => User(id: '1', email: 'a@b.com'));

    await controller.login('a@b.com', 'pass');

    verify(() => mockRepo.login('a@b.com', 'pass')).called(1);
    expect(controller.state, isA<LoginSuccess>());
  });
}
```

### BLoC / Cubit Testing

```dart
import 'package:bloc_test/bloc_test.dart';

blocTest<LoginCubit, LoginState>(
  'emits [loading, success] when login succeeds',
  build: () {
    when(() => mockRepo.login(any(), any()))
        .thenAnswer((_) async => fakeUser);
    return LoginCubit(repository: mockRepo);
  },
  act: (cubit) => cubit.login('a@b.com', 'pass'),
  expect: () => [LoginLoading(), LoginSuccess(fakeUser)],
);
```

## Widget Tests

### Basic Widget Test

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LoginPage shows email and password fields', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: LoginPage()),
    );

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Login'), findsOneWidget);
  });
}
```

### Interacting with Widgets

```dart
testWidgets('tapping login button calls onLogin', (tester) async {
  var called = false;

  await tester.pumpWidget(
    MaterialApp(
      home: LoginButton(onPressed: () => called = true),
    ),
  );

  await tester.tap(find.byType(ElevatedButton));
  await tester.pump(); // Rebuild after state change

  expect(called, isTrue);
});
```

### Pumping Variants

| Method | Use case |
|--------|---------|
| `pump()` | One frame — use after state changes |
| `pumpAndSettle()` | Pumps until no more frames — for animations |
| `pump(Duration)` | Advance time by a specific duration |

### Finders

```dart
find.text('Hello')                    // by text
find.byType(ElevatedButton)           // by widget type
find.byKey(const Key('login-button')) // by key (most reliable)
find.byIcon(Icons.email)              // by icon
find.ancestor(of: ..., matching: ...) // ancestor traversal
find.descendant(of: ..., matching: ...)
```

### Providing Dependencies in Widget Tests

```dart
// With Riverpod
await tester.pumpWidget(
  ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(MockAuthRepository()),
    ],
    child: const MaterialApp(home: LoginPage()),
  ),
);

// With BLoC
await tester.pumpWidget(
  BlocProvider<LoginCubit>(
    create: (_) => LoginCubit(repository: mockRepo),
    child: const MaterialApp(home: LoginPage()),
  ),
);
```

## Golden Tests (Screenshot Testing)

```dart
testWidgets('LoginPage matches golden', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: LoginPage()));
  await expectLater(
    find.byType(LoginPage),
    matchesGoldenFile('goldens/login_page.png'),
  );
});
```

Generate/update goldens:
```bash
flutter test --update-goldens
```

## Integration Tests

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full login flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('email-field')), 'a@b.com');
    await tester.enterText(find.byKey(const Key('password-field')), 'pass');
    await tester.tap(find.byKey(const Key('login-button')));
    await tester.pumpAndSettle();

    expect(find.text('Welcome'), findsOneWidget);
  });
}
```

Run:
```bash
flutter test integration_test/ -d <device-id>
```

## Test File Conventions

```
test/
├── features/
│   ├── auth/
│   │   ├── login_cubit_test.dart       # Unit: BLoC/Cubit
│   │   ├── auth_repository_test.dart   # Unit: repository
│   │   └── login_page_test.dart        # Widget: page
│   └── home/
│       └── home_page_test.dart
├── helpers/
│   ├── mocks.dart                      # All mock class declarations
│   ├── fakes.dart                      # Fake data / fixtures
│   └── pump_app.dart                   # Shared pumpWidget helper
└── goldens/
    └── login_page.png
```

### Shared `pumpApp` Helper

```dart
// test/helpers/pump_app.dart
extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget, {List<Override> overrides = const []}) {
    return pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(home: widget),
      ),
    );
  }
}

// Usage in tests
await tester.pumpApp(const LoginPage());
```

## Running Tests

```bash
flutter test                              # All tests
flutter test test/features/auth/          # Specific directory
flutter test --name "login"               # Tests matching name
flutter test --coverage                   # With coverage
flutter test --reporter expanded          # Verbose output
```

Coverage report:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```
