# 11 — CI/CD & Release

---

## Current CI/CD Status

**No CI/CD pipeline exists.** There are no GitHub Actions workflows, no Fastlane configuration, no Codemagic/Bitrise setup, and no Shorebird integration in this project.

The project contains:
- No `.github/workflows/` directory
- No `Fastfile` or `Appfile`
- No `codemagic.yaml`
- No `shorebird.yaml`

All builds are presumed to be run manually on the developer's machine.

---

## Build Process (Manual)

### Debug Build (Android)
```bash
flutter pub get
flutter run --debug
```

### Release Build (Android APK)
```bash
flutter build apk --release
```

### Release Build (Android App Bundle — recommended for Play Store)
```bash
flutter build appbundle --release
```

**Note:** The `pubspec.yaml` has `version: 1.0.0+1` (versionName `1.0.0`, versionCode `1`). Both should be incremented for each release.

---

## App Configuration

### App Name
`android:label="ICO Stories"` — set in `AndroidManifest.xml`

### Package Name
`com.example.ico_story_app` — still using the default Flutter example package name. **This should be changed before Play Store submission.**

### Minimum SDK
Determined by the `android/app/build.gradle.kts` file. The most restrictive package determines the actual `minSdkVersion`. `audioplayers` and `pdfx` typically require minSdk 21+.

### App Icons
Full launcher icon set is present in `android/app/src/main/res/mipmap-*/`:
- `ic_launcher.png` (all densities: mdpi through xxxhdpi)
- `ic_launcher_foreground.png` and `ic_launcher_background.png` (for adaptive icons)
- `ic_launcher_monochrome.png` (for Android 13+ themed icons)

---

## Git Workflow

**No formal Git branching strategy is documented.** The GitHub repository (`github.com/Korya0/ico_story_app`) has a `develop` branch referenced in the README badge (`last-commit/develop`), suggesting a feature branch → develop workflow, but this is not enforced by any automation.

---

## Recommended CI/CD Setup

### Option A: GitHub Actions (Free, Simple)

Create `.github/workflows/flutter_ci.yml`:

```yaml
name: Flutter CI

on:
  push:
    branches: [develop, main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test

  build:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build appbundle --release
      - uses: actions/upload-artifact@v4
        with:
          name: release-appbundle
          path: build/app/outputs/bundle/release/app-release.aab
```

### Option B: Codemagic (Simple UI, Flutter-native)
Codemagic provides a Flutter-first CI/CD with:
- Automatic build triggering on push
- Code signing management
- Direct Play Store / App Store publishing

---

## Release Checklist (Recommended Before Each Release)

- [ ] Remove `DevicePreview` wrapper from `main.dart` (or guard with `kReleaseMode`)
- [ ] Remove unused `just_audio` from `pubspec.yaml`
- [ ] Remove unused `WRITE_EXTERNAL_STORAGE` and `READ_EXTERNAL_STORAGE` permissions
- [ ] Change package name from `com.example.ico_story_app` to a production name
- [ ] Increment `version` in `pubspec.yaml`
- [ ] Run `flutter analyze` — zero issues
- [ ] Run `flutter test` — all tests pass
- [ ] Build with `--obfuscate --split-debug-info=debug-info/` for release
- [ ] Test on physical Android device (especially low-end for PDF performance)
- [ ] Verify social media links open correctly
- [ ] Verify all 68 stories open without errors

---

## Shorebird

**Status: Not implemented.**

Shorebird is a Flutter code-push solution that allows shipping Dart code updates without going through the Play Store review process. Given the app's large bundled assets, Shorebird's code-push would only update Dart code, not asset files (PDFs, MP3s). It would be valuable for quick bug fixes in the UI or Cubit logic.

---

## Summary

| Item | Status |
|---|---|
| GitHub Actions | Not configured |
| Fastlane | Not configured |
| Shorebird | Not configured |
| Codemagic/Bitrise | Not configured |
| Manual debug build | ✅ Works |
| Manual release build | ✅ Works (manual) |
| Package name | `com.example` — needs change |
| Version management | Manual — `pubspec.yaml` |
| Code signing | Manual |
| Play Store publishing | Manual |
