# Publication preparation

All package work is contained in this directory. The parent application's
pubspec, routes, Cubits, and streak widgets are unchanged.

## Confirmed decisions

- Public package name: streak_flame, selected by the owner on 2026-11-01.
  The pub.dev package API returned 404 for this name on that date; recheck before
  publication. This check does not reserve the name.
- Public entry point: lib/streak_flame.dart. Imports, tests, example metadata,
  native example names, and portable ZIP tooling use the selected name.
- Default appearance: the existing red/orange flame.
- License: MIT, copyright (c) 2026 ZakariaEysa, approved by the owner on
  2026-11-01. The complete license is included in LICENSE.
- Public contact email: zakariaeysa@gmail.com, approved by the owner and linked
  from the Contact section in README.md.
- Public source repository: https://github.com/ZakariaEysa/streak_flame.
  GitHub Issues is enabled. Repository and issue tracker URLs are configured
  in pubspec.yaml and linked from README.md.
- The current checkout folder is still streak_flame_package; its directory name
  does not determine the Dart package name.

## Required before publication

1. Recheck availability of streak_flame immediately before publication.
2. Review the exported API, supported SDK versions, and rendered design.
   Validation currently uses Flutter 3.44 / Dart 3.12; the minimum versions
   declared in pubspec.yaml still need a separate compatibility run.
3. Test representative target devices in profile mode. A web compilation or
   widget test does not establish Android/iOS runtime behavior or frame timing.
4. Review README.md, CHANGELOG.md, and the publication file list.

## Commands

Run from the package root (currently streak_flame_package), not from the parent
Flutter app:

```sh
flutter pub get
flutter analyze --no-pub
flutter test --no-pub test/streak_widget_test.dart test/streak_unified_test.dart test/streak_refactor_test.dart test/streak_dialog_test.dart test/streak_messages_test.dart test/streak_palette_test.dart test/streak_playground_test.dart test/streak_preview_page_test.dart test/visual_preview_test.dart
dart pub publish --dry-run
```

Also validate the included example:

```sh
cd example
flutter build web --no-pub
```

The dry run does not publish. LICENSE now contains the approved MIT license.
SDK dependencies are used at runtime; the example's local path dependency
is only for development. .pubignore excludes caches, builds, lock files, temporary
tools, and the two initial compatibility copies.

Once the owner has approved publication, publish from the package directory:

```sh
dart pub publish
```

Publishing is a separate external action. It has not been performed.
New releases require a new version and an updated changelog.

Official guidance: https://dart.dev/tools/pub/publishing
