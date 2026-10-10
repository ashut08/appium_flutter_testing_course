
import path from "node:path";
import { fileURLToPath } from "node:url";

// __dirname doesn't exist in ES modules ("type": "module" in package.json),
// so build it from import.meta.url.
const __dirname = path.dirname(fileURLToPath(import.meta.url));




const APK_PATH = path.resolve(__dirname, "../build/app/outputs/flutter-apk/app-debug.apk");



export const config: WebdriverIO.Config = {

    port: 4723,

    hostname: '127.0.0.1',

    specs: ['./test/**/*.spec.ts'],

    maxInstances: 1,
    capabilities: [
        {
            platformName: "Android",

            'appium:automationName': 'flutter',
            'appium:deviceName': 'emulator-5554',
            'appium:app': APK_PATH,
            'appium:newCommandTimeout': 300,
            // false = restart the app fresh each run, so Appium reads the new Dart VM URL
            'appium:noReset': false,
            'appium:fullReset': false,
            // Always install app-debug.apk (built from test_driver/app.dart), even if
            // another build of the app (e.g. from `flutter run`) is already installed.
            'appium:enforceAppInstall': true,
        }



    ],

    logLevel: 'info',
    framework: 'mocha',
    reporters: ['spec'],
    mochaOpts: {
        ui: 'bdd',
        timeout: 60000
    },

    // The first session installs UiAutomator2 + the app and connects to Flutter,
    // which can take 1–2 minutes. 12s was too short.
    connectionRetryTimeout: 240000,
    connectionRetryCount: 1,



    onPrepare() {
        console.log("Starting the test");
    },





};