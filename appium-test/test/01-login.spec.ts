
import { expect } from '@wdio/globals';
import { driver } from '@wdio/globals';
import { byText } from 'appium-flutter-finder';

import { waitFor, waitForAbsent, isPresent, key, type, tap, login, openLogin } from '../helper/flutter.js';

describe('Login: Interaction test cases', () => {

    /**
     * After every test navigate back to the home screen so that
     * openLogin() in the next beforeEach always finds 'open_login'.
     *
     * Navigation stack:  Home → LoginPage → WelcomePage
     * We press back up to 3 times until the 'open_login' button is visible.
     */
    afterEach(async () => {
        for (let i = 0; i < 3; i++) {
            const onHome = await isPresent(key('open_login'), 500);
            if (onHome) break;
            await driver.back();
            await driver.pause(500);
        }
    });

    /** Open the login page before every test for full isolation. */
    beforeEach(async () => {
        await openLogin();
    });

    // ─── Negative Test Cases ─────────────────────────────────────────────

    // TC 01 - Negative
    it('empty form shows both validation messages', async () => {

        await tap(key('login_button'));

        await waitFor(byText('Email is required'));
        await waitFor(byText('Password must be at least 6 characters'));
    });

    // TC 02 - Negative
    it('invalid email format shows validation message', async () => {

        await login('student', 'password123');

        await waitFor(byText('Enter a valid email'));
    });

    // TC 03 - Negative
    it('wrong credentials shows error message', async () => {

        await login('wrong@test.com', 'wrongpass');

        await waitFor(byText('Invalid email or password'), 5000);
    });

    // TC 04 - Negative
    it('correct email but wrong password shows error message', async () => {

        await login('student@test.com', 'badpass');

        await waitFor(byText('Invalid email or password'), 5000);
    });

    // TC 05 - Negative
    it('short password shows validation message', async () => {

        await type(key('email_field'), 'test@example.com');
        await type(key('password_field'), '123');       // < 6 chars
        await tap(key('login_button'));

        await waitFor(byText('Password must be at least 6 characters'));
    });

    // ─── Positive Test Cases ─────────────────────────────────────────────

    // TC 06 - Positive
    // NOTE: The loading_indicator only shows for ~2 seconds. Appium's WebDriver
    // round-trip latency (test → Appium server → device → Flutter driver) often
    // exceeds that window, making waitFor(loading_indicator) unreliable.
    // Instead we assert the end-state: login_button disappears AND welcome page appears,
    // which proves the full loading → navigation flow completed successfully.
    it('valid credentials trigger the login flow and navigate to welcome page', async () => {

        await type(key('email_field'), 'student@test.com');
        await type(key('password_field'), 'password123');
        await tap(key('login_button'));

        // login_button is replaced by the spinner while loading — confirms loading started
        await waitForAbsent(key('login_button'), 4000);

        // After the 2-second delay the app navigates to WelcomePage
        await waitFor(byText('Welcome, student@test.com!'), 5000);
    });

    // TC 07 - Positive
    it('successful login navigates to the welcome page', async () => {

        await login('student@test.com', 'password123');

        // After the 2-second server delay the welcome text must appear
        await waitFor(byText('Welcome, student@test.com!'), 5000);
    });

    // TC 08 - Positive
    it('welcome page displays the correct user name', async () => {

        await login('student@test.com', 'password123');

        await waitFor(key('welcome_text'), 5000);

        const text = await driver.getElementText(key('welcome_text'));
        expect(text).toBe('Welcome, student@test.com!');
    });

    // TC 09 - Positive
    it('no error message is shown after a successful login', async () => {

        // Type credentials but do NOT tap login yet — error widget should be absent
        await type(key('email_field'), 'student@test.com');
        await type(key('password_field'), 'password123');

        // Confirm error widget is absent before submitting
        await waitForAbsent(key('login_error'), 1000);

        await tap(key('login_button'));

        // After login, WelcomePage has no login_error widget either
        await waitFor(byText('Welcome, student@test.com!'), 5000);
        await waitForAbsent(key('login_error'), 1000);
    });

    // TC 10 - Positive
    // The login_button and loading_indicator are mutually exclusive in the widget tree
    // (see login_page.dart: _loading ? CircularProgressIndicator : FilledButton).
    // Once login succeeds the whole LoginPage is popped — asserting login_button is absent
    // on WelcomePage proves the conditional rendering worked correctly end-to-end.
    it('login button is not present on the welcome page after successful login', async () => {

        await login('student@test.com', 'password123');

        // Wait for WelcomePage to load
        await waitFor(byText('Welcome, student@test.com!'), 5000);

        // login_button must NOT exist on WelcomePage
        await waitForAbsent(key('login_button'), 1000);
    });

});