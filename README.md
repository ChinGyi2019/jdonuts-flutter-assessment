# J’Donuts Flutter assessment

A mobile prototype that covers onboarding, simulated sign-in and registration, a donut catalog and product details, and an animated member rewards screen. The app runs on Android and iOS Simulator with local data. It needs no account with an external service, API key, or backend.

## Run locally

This project pins **Flutter 3.38.4** and **Dart 3.10.3** through FVM. Use Android Studio and an Android emulator for Android. For iOS Simulator, use macOS with Xcode, an installed Simulator runtime, and CocoaPods.

```sh
fvm install
fvm flutter pub get
fvm flutter devices
fvm flutter run -d <device-id>
```

Select **Let’s get started**, enter a Myanmar mobile number such as `09254135592`, and use the demo OTP **`123456`**. Complete your name and birthday, then tap **Let’s explore**. You can sign out in Settings and sign back in with the same number. The app retains the registration and restores an active session when reopened.

To try offline mode, enable airplane mode and disable Wi-Fi before opening a fresh install. Register locally, then visit Home, a product, and Rewards. Reconnect to trigger a background refresh, or pull down on Home to refresh manually.

## What I implemented

| Assessment area | Implementation |
| --- | --- |
| Onboarding and authentication | Separate registration and returning login flows with Myanmar phone normalization, numeric OTP entry and paste, resend countdown and attempt limits, and name and age validation. Registration is stored locally. Secure storage retains the active member ID, and GoRouter guards signed-in routes. |
| Offline Home and Product detail | Drift supplies a reactive catalog seeded from bundled JSON. Home shows a banner carousel, product sections, nearby shops, and the signed-in member’s tier. Product tiles open `/product/:id` with an image Hero transition, quantity controls, and a live MMK total. |
| Rewards | Home and Rewards read the same member and tier data. Rewards animates the points count and ring, tier progress, badge, tab indicator, and challenge artwork. The completed challenge gives press feedback. |
| Onboarding and Welcome motion | Onboarding brings the donut illustrations in one at a time, then lets them float gently. Welcome scrolls two columns of donut artwork in opposite directions and staggers the entrance of the title and **Let’s explore** button. Both screens respect the system’s reduced-motion preference. |
| Motion and accessibility | Animated registration progress, OTP shake, Home skeletons and section entrances, a sliding navigation pill, and reduced-motion support. |

## Bonus features

- **Burmese (မြန်မာ) translation.** Switch between English and Burmese in Settings. The app remembers the language between launches and uses Flutter’s generated localizations from ARB files.
- **Fly-to-cart animation.** Tap **Add to cart** on Product Detail to send the product artwork along an arc into the cart icon. The icon pulses as the item count updates. With reduced motion enabled, the count updates without the flight.

## Architecture and offline behavior

```text
lib/app/          Bootstrap, session state, GoRouter, and navigation shell
lib/core/         Drift, Hive, connectivity, images, typed failures, and design tokens
lib/features/     Auth, Home, Product, Rewards, Settings, and cart state
lib/l10n/         English and Burmese ARB sources and generated localizations
assets/           Bundled catalog, artwork, and fonts
test/             Domain, repository, ViewModel, storage, and widget tests
integration_test/ Registration journey and compact artwork checks
```

Feature folders separate presentation, domain contracts, and data implementations. I chose Riverpod because generated providers make dependencies explicit and let tests substitute repositories, session storage, and connectivity without changing screens. Repositories return typed failures with `Either`, and the domain can be used without Flutter UI dependencies.

Drift is the source of truth for the catalog and member data. A versioned seed transaction initializes or updates catalog rows while preserving registrations. The app combines transport changes from `connectivity_plus` with a bounded HTTP reachability probe. Reconnect and pull-to-refresh share the same refresh operation and keep the existing catalog if refresh fails. Bundled images work on the first offline launch. The shared image loader also supports a disk cache and asset fallback for URL-backed images. Hive stores the language preference, and `flutter_secure_storage` stores the session ID.

## Test and build

```sh
fvm flutter analyze
fvm flutter test
fvm flutter test integration_test/registration_catalog_test.dart -d <device-id>
fvm flutter build apk --release
fvm flutter build ios --simulator --no-codesign
ditto -c -k --sequesterRsrc --keepParent build/ios/iphonesimulator/Runner.app JDonuts-iOS-Simulator.zip
```

The registration journey uses seeded Drift data and simulated offline status. The separate artwork check exercises a compact viewport at 1.3× text size with motion enabled and reduced. If provider, schema, or ARB inputs change, regenerate with `fvm dart run build_runner build` and `fvm flutter gen-l10n`.

The APK is written to `build/app/outputs/flutter-apk/app-release.apk`. It uses the Android debug signing key for sideloading. To install the unzipped Simulator build, boot the target Simulator and run `xcrun simctl install booted Runner.app` from the extracted directory.

## Scope and time spent

Authentication, social sign-in, cart feedback, and rewards redemption are demo flows. No real SMS, checkout, or redemption service is connected. The bundled catalog is the refresh source. Android and iOS Simulator are the delivery targets, and browser SQLite is outside this build. Physical-device frame pacing was not benchmarked for this submission.

Time spent on implementation and validation was **14 hours 27 minutes**, from 9:00 AM to 11:27 PM on 11 November 2026 (Bangkok time, UTC+7).
