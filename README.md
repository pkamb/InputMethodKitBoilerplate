# InputMethodKitBoilerplate

Boilerplate for an Input Method Kit input method for macOS

### Installing the Input Method

1. Create a new OS X user account for testing input methods. *Much* easier than continually logging in and out from your main OS X account.
2. Build the InputMethodKitBoilerplate project via Xcode.
3. Move the resulting `InputMethodKitBoilerplate.app` file to `/Library/Input Methods/`.
4. Log In to your separate user account for testing.
5. Add the new input method via `System Preferences > Keyboard > Input Sources > English > InputMethodKitBoilerplate`.
6. Log Out of the testing account when you're finished testing the input method.
7. If you make Changes to the Xcode project, re-build the target and move the app into `/Library/Input Methods/`.
8. Log in to your test user account to test the input method.
