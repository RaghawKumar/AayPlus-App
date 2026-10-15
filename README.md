# AayPlus mobile app

Flutter app for discovering rentals, managing listings, booking handovers and reviewing inspection evidence. It connects to the separate AayPlus Node.js backend.

## Run

```sh
flutter pub get
flutter run
```

Default API: `http://10.0.2.2:8080/api/v1` on Android emulators, `http://localhost:8080/api/v1` elsewhere. Override with `flutter run --dart-define=API_BASE_URL=https://your-api.example/api/v1`.

On iOS, fully restart/rebuild after native plugin changes; hot reload does not install camera/video plugins. Real camera capture needs a physical device.

## Validate

```sh
flutter test
flutter analyze --no-fatal-infos
```

## Guides

- [Setup and client integration](docs/INTEGRATION.md)
- [Complete app flow and screen details](docs/APP-FLOW.md)
- [UI review and current boundaries](docs/UX-REVIEW.md)
- [Three-repository workspace](docs/REPOSITORIES.md)

Development OTPs and admin verification are supported. Real SMS, identity-provider checks and payments are not configured. Tokens stay in memory; marketplace records persist on the backend.
