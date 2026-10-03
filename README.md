# Flutter Testing Practice: Counter App

A small counter app for learning the three kinds of Flutter tests:
**unit tests**, **widget tests**, and **integration tests**.

The app has one number on screen and three buttons:

| Button | Key | What it does |
|---|---|---|
| ➕ (floating button) | `increment` | Adds 1 |
| ➖ | `decrement` | Subtracts 1 |
| Reset | `reset` | Sets the count back to 0 |

The number itself has the key `counter`. Tests use these keys to find widgets.

---

## Project structure

```
lib/
  main.dart                 # Entry point: PracticeApp (MaterialApp) → CounterApp
  counter_app.dart          # The counter screen (UI)
  counter_controller.dart   # The counting logic (no UI)

test/                       # Runs on your computer, no device needed
  counter_controller_test.dart   # Unit test
  widget_test.dart               # Widget test

integration_test/           # Runs the real app on a device/emulator
  counter_test.dart              # Integration test
```

---

## The three kinds of tests

### 1. Unit test: [test/counter_controller_test.dart](test/counter_controller_test.dart)
Tests **plain Dart logic** (`CounterController`) with no UI at all.
It's the fastest kind of test.

```dart
final controller = CounterController();
controller.increment();
expect(controller.count, 1);
```

### 2. Widget test: [test/widget_test.dart](test/widget_test.dart)
Builds **one screen** in a fake test environment, taps buttons, and checks the
text. No device is needed.

```dart
await tester.pumpWidget(const MaterialApp(home: CounterApp()));
await tester.tap(find.byKey(const ValueKey('increment')));
await tester.pump();   // rebuild the UI after the tap
```

### 3. Integration test: [integration_test/counter_test.dart](integration_test/counter_test.dart)
Runs the **whole app on a real device, emulator, or desktop**, the same way a
user would use it. It's the slowest kind of test and the closest to real use.

```dart
IntegrationTestWidgetsFlutterBinding.ensureInitialized();  // required!
await tester.pumpWidget(const PracticeApp());
```

---

## Setup

1. Install Flutter: https://docs.flutter.dev/get-started/install
2. Get the dependencies:

```bash
flutter pub get
```

The `integration_test` package is already listed under `dev_dependencies` in
`pubspec.yaml`.

---

## Running the tests

**Unit + widget tests** (everything in `test/`):

```bash
flutter test
```

**See which devices are available:**

```bash
flutter devices
```

**Integration test on an Android emulator** (start the emulator first):

```bash
flutter test integration_test/counter_test.dart -d emulator-5554
```

**Integration test on macOS desktop** (no emulator needed):

```bash
flutter test integration_test/counter_test.dart -d macos
```

Replace `emulator-5554` with the device ID that `flutter devices` shows.

---

## Tip: slow the test down so you can watch it

Integration tests run very fast. To see each tap happen on the emulator, add a
short pause after each step:

```dart
await tester.tap(increment);
await tester.pumpAndSettle();
await Future.delayed(const Duration(seconds: 1));   // pause for 1 second
```

Remove the pauses when you're done watching, so the tests stay fast.

---

## Common mistakes (and fixes)

| Error you see | Why it happens | Fix |
|---|---|---|
| `No Directionality widget found` / `No MediaQuery widget found` | You pumped a screen (a `Scaffold`) with no `MaterialApp` around it | Pump `PracticeApp()`, or wrap the screen: `MaterialApp(home: CounterApp())` |
| `integration_test plugin was not detected` | The test file is in `test/` instead of `integration_test/` | Move it to the `integration_test/` folder at the project root |
| `Failed to load ... Does not exist` | The file name or path in the command is wrong | Check the name with `ls integration_test` |
| `Found 0 widgets with text "1"` right after a tap | The UI hasn't rebuilt yet | Call `await tester.pump();` after every `tap` |
| `No devices found` / phone not detected | The device is locked, unplugged, or not in Developer Mode | Unlock it, connect it with a cable, and run `flutter devices` again |

---

## Practice exercises

1. Add a unit test for `reset()` in `counter_controller_test.dart`.
2. In the integration test, tap decrement until the counter reaches `-3`, then check it.
3. Add a "+5" button with key `increment_5`, then write a widget test for it.
4. Check the app bar title with `find.text('Conter App')`. Then fix the typo in
   the app and watch the test fail. Update the test to match.

## Learn more

- [Flutter testing overview](https://docs.flutter.dev/testing/overview)
- [Integration testing guide](https://docs.flutter.dev/testing/integration-tests)
- [Widget testing cookbook](https://docs.flutter.dev/cookbook/testing/widget/introduction)
