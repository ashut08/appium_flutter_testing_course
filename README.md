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
  list_page.dart            # Fruit product list (keys: product_list, product_0 …)
  list_details_page.dart    # Product detail screen (key: detail_text)
  login_page.dart           # Login form (keys: email_field, password_field, login_button, login_error)
  welcomepage.dart          # Shown after a successful login

test/                       # Runs on your computer, no device needed
  counter_controller_test.dart   # Unit test
  widget_test.dart               # Widget test

integration_test/           # Runs the real app on a device/emulator
  counter_test.dart              # Integration test

test_driver/                # Flutter Driver tests (app + test run separately)
  app.dart                       # Starts the app with the driver extension enabled
  list_test.dart                 # Driver test for the fruit product list

appium-test/                # Appium + WebdriverIO tests (Node.js / TypeScript)
  package.json                   # npm dependencies and the `npm test` script
  wdio.conf.ts                   # WebdriverIO config: Appium server + device capabilities
  tsconfig.json                  # TypeScript settings
  helper/flutter.ts              # Reusable actions: tap, type, waitFor, login …
  test/                          # Appium test specs (smoke, login)
  LOGIN_TESTS.md                 # Lesson notes: helpers + login test cases
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

**Flutter Driver test** (fruit product list in [test_driver/list_test.dart](test_driver/list_test.dart)):

`flutter drive` builds and launches [test_driver/app.dart](test_driver/app.dart)
(the app with `enableFlutterDriverExtension()`), then runs the test script
against it from your computer.

```bash
flutter drive --target=test_driver/app.dart --driver=test_driver/list_test.dart
```

On a specific device, e.g. an Android emulator or macOS desktop:

```bash
flutter drive --target=test_driver/app.dart --driver=test_driver/list_test.dart -d emulator-5554
```

```bash
flutter drive --target=test_driver/app.dart --driver=test_driver/list_test.dart -d macos
```

Test cases it covers:

| Test | What it checks |
|---|---|
| `first product should be apple` | Taps `open_list`, opens `product_0`, expects `detail_text` to be "You have opened Apple with price 12.99", then goes back to the list |
| `Scroll to last product open it and go back` | Scrolls `product_list` until `product_39` is visible, expects its name to be "Grapes", opens it, expects "You have opened Grapes with price 19.99", then goes back |

---

## Appium testing (step by step)

Flutter's own tests (unit, widget, integration, driver) are written in Dart.
**Appium** is different: it's a server that drives a real app on a phone or
emulator, and you write the tests in any language. This project uses
**JavaScript/TypeScript with WebdriverIO** in the `appium-test/` folder.

How the pieces fit together:

```
WebdriverIO test (appium-test/test/*.ts)
        │  HTTP (port 4723)
        ▼
Appium server  ──►  Flutter driver  ──►  your app on the emulator
                    (uses UiAutomator2 on Android / XCUITest on iOS)
```

### Step 1: Install the tools you need first

| Tool | Why you need it | Check it's installed |
|---|---|---|
| **Flutter SDK** | Builds the app | `flutter doctor` |
| **Node.js 20.19+ or 22.12+ (LTS)** | Appium and WebdriverIO run on Node | `node -v` and `npm -v` |
| **Java JDK 17** | Needed by Android tools and UiAutomator2 | `java -version` |
| **Android Studio** | Android SDK, platform-tools (`adb`), and the emulator | `adb version` |
| **Xcode** (macOS only, for iOS) | iOS simulator and the XCUITest driver | `xcodebuild -version` |

Install Node.js from https://nodejs.org (choose **LTS**). On macOS you can also
use Homebrew:

```bash
brew install node
```

### Step 2: Set the Android environment variables

Appium finds the Android SDK through `ANDROID_HOME` and Java through
`JAVA_HOME`. On macOS, add these lines to `~/.zshrc`:

```bash
export ANDROID_HOME=$HOME/Library/Android/sdk
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH=$PATH:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator
```

Then reload the shell:

```bash
source ~/.zshrc
```

On **Windows**, open *System Properties → Environment Variables* and add
`ANDROID_HOME` = `C:\Users\<you>\AppData\Local\Android\Sdk`, `JAVA_HOME` = your
JDK folder, and add `%ANDROID_HOME%\platform-tools` and
`%ANDROID_HOME%\emulator` to `Path`. Open a new terminal afterwards.

### Step 3: Install Appium

Appium is installed globally with npm, so the `appium` command works everywhere:

```bash
npm install -g appium
```

Check the version (this project was set up with Appium 3.x):

```bash
appium -v
```

### Step 4: Install the Appium drivers

Appium itself can't control any app until you install a **driver** for it.
For this project you need:

| Driver | What it's for | Required? |
|---|---|---|
| `flutter` (appium-flutter-driver) | Finds Flutter widgets by `ValueKey`, text, type, etc. | **Yes** |
| `uiautomator2` | Controls Android devices/emulators. The Flutter driver uses it underneath on Android | **Yes** (Android) |
| `xcuitest` | Controls iOS simulators/devices | Only for iOS (macOS) |

Install them:

```bash
appium driver install --source=npm appium-flutter-driver
```

```bash
appium driver install uiautomator2
```

```bash
appium driver install xcuitest
```

Check what's installed:

```bash
appium driver list --installed
```

You should see `flutter`, `uiautomator2` (and `xcuitest` on macOS).

To update the drivers later:

```bash
appium driver update flutter
```

### Step 5: Check your setup with Appium Doctor

Each driver has a "doctor" that tells you what's missing (e.g. `ANDROID_HOME`
not set, no JDK):

```bash
appium driver doctor uiautomator2
```

Fix everything marked with ✖ before you continue. Optional items (⚠) can be
skipped.

### Step 6: Build the app with the Flutter Driver extension

The Appium Flutter driver talks to the app through the **Flutter Driver
extension**, so the APK must be built from [test_driver/app.dart](test_driver/app.dart)
(which calls `enableFlutterDriverExtension()`), **not** from `lib/main.dart`,
and it must be a **debug** build:

```bash
flutter build apk --debug --target=test_driver/app.dart
```

The APK is created at `build/app/outputs/flutter-apk/app-debug.apk`.
`wdio.conf.ts` points `appium:app` at this file.

### Step 7: Start an emulator

Start it from Android Studio (*Device Manager → ▶*), or from the terminal:

```bash
emulator -list-avds
```

```bash
emulator -avd <name-from-the-list>
```

Make sure it shows up as `device` (the ID is usually `emulator-5554`, which is
what `wdio.conf.ts` uses in `appium:deviceName`):

```bash
adb devices
```

### Step 8: Start the Appium server

Open a **separate terminal** and leave it running:

```bash
appium
```

You should see `Appium REST http interface listener started on http://0.0.0.0:4723`
and the list of available drivers.

### Step 9: Install the test project's npm packages

In another terminal, from the project root:

```bash
cd appium-test
```

```bash
npm install
```

This creates `appium-test/node_modules/`. It's large and is ignored by
`.gitignore`, so **every student must run `npm install` after cloning**.

Packages used (already listed in `package.json`):

| Package | Purpose |
|---|---|
| `webdriverio`, `@wdio/cli` | The test client and the `wdio` command |
| `@wdio/local-runner` | Runs the specs on your machine |
| `@wdio/mocha-framework` | `describe` / `it` test syntax |
| `@wdio/spec-reporter` | Readable test output in the terminal |
| `appium-flutter-finder` | `byValueKey`, `byText`, `byType`… finders for Flutter widgets |
| `typescript`, `@types/node` | TypeScript support |

### Step 10: Run the Appium tests

With the emulator and the Appium server both running:

```bash
npm test
```

This runs `wdio run wdio.conf.ts`, which installs the APK on the emulator,
opens the app and runs the specs in `appium-test/test/`.

### Writing an Appium test with Flutter finders

```ts
import { byValueKey } from 'appium-flutter-finder';

describe('Counter', () => {
  it('increments the counter', async () => {
    await driver.elementClick(byValueKey('increment'));
    const text = await driver.getElementText(byValueKey('counter'));
    expect(text).toBe('1');
  });
});
```

Keys you can use in this app: `counter`, `increment`, `decrement`, `reset`,
`open_list`, `open_login`, `product_list`, `product_<index>`, `detail_text`,
`email_field`, `password_field`, `login_button`, `login_error`,
`loading_indicator`, `welcome_text`. The eye icon has the tooltip
`Show password` / `Hide password`.

Test login: email `student@test.com`, password `password123`.

### Appium: common problems

| Error you see | Fix |
|---|---|
| `appium: command not found` | Run `npm install -g appium` and open a new terminal |
| `Could not find a driver for automationName 'Flutter'` | Run `appium driver install --source=npm appium-flutter-driver` |
| `ANDROID_HOME is not set` / `JAVA_HOME is not set` | Do Step 2, then restart the terminal **and** the Appium server |
| `ECONNREFUSED 127.0.0.1:4723` | The Appium server isn't running. Start it with `appium` |
| `Could not find a connected Android device` | Start the emulator and check `adb devices` |
| `The application at '...app-debug.apk' does not exist` | Build it first (Step 6) |
| Flutter driver can't connect / hangs at `Connecting to Dart Observatory` | The APK was built from `lib/main.dart` or in release mode. Rebuild with `--debug --target=test_driver/app.dart` |
| `ReferenceError: __dirname is not defined in ES module scope` | `package.json` has `"type": "module"`, and ES modules don't have `__dirname`. In `wdio.conf.ts` create it: `const __dirname = path.dirname(fileURLToPath(import.meta.url));` (import `fileURLToPath` from `node:url`) |
| `pattern ./test/**/*.spec.ts did not match any file` / `spec file(s) ... not found` | Test files must end in `.spec.ts` (singular) to match `specs` in `wdio.conf.ts`. Check the exact name with `ls test` |
| `Failed to create a session: Request timed out! Consider increasing the "connectionRetryTimeout"` | Starting the first session (installing UiAutomator2 + the app, connecting to Flutter) can take 1–2 minutes. Set `connectionRetryTimeout: 240000` in `wdio.conf.ts`. If it still times out, read the Appium server terminal for the real error |
| `Cannot connect to the Dart Observatory URL ws://127.0.0.1:.../ws` | Another Flutter tool is attached to the app, or Appium read an old URL from a previous run. Stop any `flutter run` / IDE debug session on the emulator, run `adb shell am force-stop com.example.appiumtesting`, rebuild with `flutter build apk --debug --target=test_driver/app.dart`, and keep `'appium:noReset': false` in `wdio.conf.ts` so the app restarts fresh |
| `Cannot execute command waitFor` / test times out after 60s | The `ValueKey` you're waiting for doesn't exist on that screen. Check the spelling against the keys listed above |
| `Cannot find module 'webdriverio'` | Run `npm install` inside `appium-test/` |

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
| `DriverError: ... get_text: Bad state: No element` | A Flutter Driver finder matched nothing, e.g. `find.byType("text")` (the type name is case-sensitive) | Use the exact class name: `find.byType("Text")`, or check the `ValueKey` spelling |
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
- [Appium documentation](https://appium.io/docs/en/latest/)
- [Appium Flutter driver](https://github.com/appium/appium-flutter-driver)
- [WebdriverIO documentation](https://webdriver.io/docs/gettingstarted)
