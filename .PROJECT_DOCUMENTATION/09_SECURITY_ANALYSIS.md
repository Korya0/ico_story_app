# 09 — Security Analysis

---

## Overview

ICO Stories is an offline-first, locally-bundled application with no user accounts, no authentication, and no backend communication. The security attack surface is minimal. However, several Android-level and code-level points are worth documenting.

---

## Authentication & Authorization

**Status: Not implemented.**

The app has no user login, no accounts, no session management, and no access control. All content is freely accessible to anyone who launches the app. This is appropriate for a children's story app.

---

## Token Handling

**Status: Not applicable.**

No tokens, API keys, JWTs, or OAuth flows exist in the codebase. There is no backend API.

---

## Secure Storage

**Status: Not implemented.**

The only persisted data is a single boolean flag (`showOnboarding`) stored in `SharedPreferences`. This is not sensitive data. `flutter_secure_storage` is not used or needed.

No passwords, PII, or sensitive credentials are stored on device.

---

## Network Security

### INTERNET Permission
Declared in `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

The `INTERNET` permission is present despite the app making no network requests to its own backend. This permission exists because:
1. `url_launcher` opens social media links in the browser (technically a system call, not a direct network request from the app)
2. `device_preview` may require network access in development

**Risk:** Low. The app does not transmit any user data over the network. The permission enables outbound URL launching only.

### Network Communication
The only outbound "network" action is `url_launcher` opening the following hardcoded URLs:
- `https://x.com/ICOnetwork`
- `https://www.facebook.com/ICONetwork`
- `https://www.instagram.com/iconetwork/`

These are launched in the system browser via `LaunchMode.externalApplication`. The app does not make any HTTP requests itself.

---

## Storage Permissions

### WRITE_EXTERNAL_STORAGE and READ_EXTERNAL_STORAGE
```xml
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

**These permissions are declared but not used in the reviewed Dart code.** The app reads PDF and audio files from bundled Flutter assets, not from external storage. These permissions are likely leftovers from an earlier development phase (possibly `flutter_pdfview` or another package that was later replaced).

**Risk:** Medium. Requesting unused permissions increases the app's apparent permission scope unnecessarily, which can raise user concern and potentially cause issues in app store review. On Android 13+, `READ_EXTERNAL_STORAGE` is deprecated and replaced with granular media permissions.

**Recommendation:** Remove both storage permissions from `AndroidManifest.xml`.

---

## Encryption

**Status: Not implemented.**

No data encryption is applied anywhere. The bundled PDF and MP3 assets are readable by anyone who extracts the APK, as is standard for locally-bundled Flutter assets.

If content protection were a requirement, assets could be encrypted and decrypted at runtime, but this adds significant complexity and is not standard practice for educational content apps.

---

## Input Validation

**Status: Not applicable / Minimal.**

The app has no user text input fields. The only external input is:
- Route `extra` parameters from GoRouter navigation (page-internal navigation, not user-controlled)
- Category ID string (`char`, `tarbawia`, `sira`) passed through navigation extras

The category ID is used in a `switch` statement with a safe default, so invalid values fall through to a default case.

---

## Hardcoded Social Media URLs

**File:** `lib/core/constants/app_keys.dart`

```dart
static const String twitterLink = 'https://x.com/ICOnetwork';
static const String facebookLink = 'https://www.facebook.com/ICONetwork';
static const String instaLink = 'https://www.instagram.com/iconetwork/';
```

URLs are hardcoded in Dart constants. If these accounts change, an app update is required. There is no SSRF or injection risk as these are passed through `url_launcher` to the OS, not to an HTTP client.

---

## DevicePreview in Production

**File:** `lib/main.dart`

```dart
runApp(
  DevicePreview(
    builder: (context) => const MyApp(),
  ),
);
```

`DevicePreview` is unconditionally active. This is a **development tool** that:
- Exposes a device-selection panel
- May include additional logging
- Adds unnecessary code and potentially data to production builds

**Risk:** Low-medium for a production release. It does not expose sensitive data but reduces professionalism and adds bundle overhead.

**Recommendation:** Wrap with `kReleaseMode` condition:
```dart
runApp(
  kReleaseMode
    ? const MyApp()
    : DevicePreview(builder: (context) => const MyApp()),
);
```

---

## Code Obfuscation

**Status: Unknown.** No `--obfuscate` flag configuration was found in build files or CI configuration (there is no CI). If the app is distributed via Play Store, `--obfuscate --split-debug-info` should be used in the release build command to protect Dart code from reverse engineering.

---

## Security Summary

| Area | Status | Risk Level |
|---|---|---|
| Authentication | Not applicable | None |
| Token/Secret handling | Not applicable | None |
| Secure storage | Not needed (no sensitive data) | None |
| Network communication | url_launcher only (browser handoff) | Very Low |
| INTERNET permission | Present, minimal use | Low |
| Storage permissions (unused) | Declared but not used | Medium |
| Content encryption | Not implemented | Low (educational content) |
| DevicePreview in prod | Active unconditionally | Low-Medium |
| Production crash reporting | None | Medium (ops risk) |
| Code obfuscation | Unknown/likely missing | Medium |
