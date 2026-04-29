# Repository Guidelines

## Project Structure & Module Organization
`lib/main.dart` is the current app entrypoint and contains the main UI and state logic for the study supervisor app. Put new Dart code under `lib/` and prefer splitting new features into focused files instead of growing `main.dart` further. Tests live in `test/`, with the current widget coverage in `test/widget_test.dart`.

Platform runners are in `android/`, `ios/`, `linux/`, `macos/`, `windows/`, and `web/`; treat these as platform-specific glue unless a feature requires native changes. CI and release automation live in `.github/workflows/`. Update `pubspec.yaml` when adding packages or registering assets.

## Build, Test, and Development Commands
- `flutter pub get` installs Dart and Flutter dependencies.
- `flutter run -d chrome` runs the app locally in a browser.
- `flutter run -d linux` runs the desktop build on Linux.
- `flutter analyze` checks code against the configured lints.
- `flutter test` runs the widget and unit tests under `test/`.
- `flutter build apk --release --split-per-abi` builds Android release artifacts.
- `flutter build web --release` creates the production web bundle.

## Coding Style & Naming Conventions
Use standard Dart style: 2-space indentation, trailing commas where formatter-friendly, and `dart format lib test` before opening a PR. Follow `flutter_lints` from `analysis_options.yaml`.

Use `PascalCase` for classes and enums, `lowerCamelCase` for methods, variables, and parameters, and leading `_` for private members. Keep widget classes descriptive, such as `StudyHomePage`, and group persistence keys and constants near the state that owns them.

## Testing Guidelines
Use `flutter_test` and keep tests in files named `*_test.dart`. Prefer `testWidgets(...)` for UI behavior and mock local persistence when needed, as the current suite does with `SharedPreferences.setMockInitialValues({})`.

There is no explicit coverage gate, but new behavior should include at least one focused test. Run `flutter test` and `flutter analyze` before pushing.

## Commit & Pull Request Guidelines
Recent commits use short, imperative, lowercase subjects such as `add release workflow` and `fix widget test entrypoint`. Keep commit messages concise and specific.

PRs should include a short summary, the commands you ran to verify the change, and screenshots for visible UI updates. Link the related issue when applicable. Tags matching `v*` trigger the release workflow, so use version tags intentionally.
