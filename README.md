# app_frontend

## Installation & Setup

### Prerequisites

- Flutter ^3.19.3
- Dart ^3.3.1
- Android Emulator and/or iOS Simulator + Xcode

### Install packages

Install the packages & libraries from `pom.xml` using:

```
flutter pub get
```

#### Link `app_backend` to local package (optional)

If you don't have access to the GitHub repository or `flutter pub get` is unable to download it, you can link to the app_backend package locally. Therefore, you have to change the app_backend dependency inside of the `pom.xml`:

```yaml
app_backend:
  path: ../url/to/local/app_backend-repo # e.g. ../app_backned
```

Then run `flutter pub get` again.

### Start app

Run using your IDE's run functionality or:

```
flutter run
```

Depending on the targetted mobile OS/platform, an emulator/simulator has to be installed and/or already started.

### Run tests

All frontend integration tests can be ran using:

```
flutter test <path-to-integration-test>
```

Execute the tests in the following order:
- 'integration_test/onboarding_test.dart'
- 'integration_test/donation_integration_test.dart'
- 'integration_test/tracking_test.dart'
- 'integration_test/after_onboarding_integration_test.dart'

The servers needs to be running and cleaned before running the tests.

Unit tests of Frontend functionality are located in the `app-backend` package.

### Learn More

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
