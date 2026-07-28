# 03 — Tech Stack & Skills

All technologies listed here are verified as actually present and used in the codebase.

---

## Flutter & Dart

| Item | Detail |
|---|---|
| **Flutter SDK** | Framework for cross-platform UI |
| **Dart SDK** | `^3.8.1` |
| **Target Platforms** | Android (primary), Web (scaffold only) |
| **Design System** | Custom — `AppColors`, `AppTheme`, reusable widget library in `core/widgets/` |

---

## State Management

### Cubit / BLoC — `flutter_bloc: ^9.0.0`

Two Cubits are implemented:

**`HomeCubit`** (`lib/features/home/presentation/cubits/home_cubit/`)
- States: `HomeInitial`, `HomeLoading`, `HomeCategoriesLoaded`, `HomeStoriesLoaded`, `HomeError`
- Responsibilities: load story categories, load stories by category

**`AudioCubit`** (`lib/features/home/presentation/cubits/audio_cubit.dart`)
- Custom state class `AudioState` with `copyWith` pattern
- Manages play/pause/seek/restart and audio stream subscriptions
- Handles app lifecycle events (pauses audio on `AppLifecycleState.paused`)

**`AppBlocObserver`** (`lib/core/services/app_bloc_observer.dart`)
- Implements `onCreate`, `onEvent`, `onChange`, `onError`, `onClose`
- Truncates large state/event strings to 200 characters for readable logs

---

## Navigation

### GoRouter — `go_router: ^16.2.1`

Defined in `lib/core/router/app_router.dart`.

| Route | Path | Extra Parameters |
|---|---|---|
| Onboarding | `/onboarding` | None |
| Home | `/home` | None |
| Stories List | `/storiesList` | `categoryTitle: String` |
| Story Reader | `/storyReader` | `story: StoryModel`, `categoryId: String?` |

**Initial route logic**: reads `SharedPreferences` at startup to decide whether to show onboarding or go directly to home:

```dart
initialLocation: SharedPref().getBoolean(PrefKeys.showOnboarding) ?? false
    ? AppRoutes.home
    : AppRoutes.onboarding,
```

**Page transitions**: uses `MaterialPage` (natural platform transition) via `naturalTransition()` helper.

---

## Storage

### SharedPreferences — `shared_preferences: any`

Used only for one purpose: persisting whether the user has completed onboarding.

- Key: `showOnboarding` (defined in `AppKeys`)
- Wrapper: `SharedPref` singleton (`lib/core/services/shared_pref.dart`)
- Methods: `setBoolean(key, booleanValue)`, `getBoolean(key)`

No other data is persisted to disk.

---

## PDF Viewing

### pdfx — `pdfx: ^2.9.2`

Used in `lib/features/home/presentation/widgets/story_reader/pdf_book_flip_local.dart`.

Pipeline:
1. `PdfDocument.openAsset(path)` — opens PDF from Flutter assets
2. Iterates all pages: `doc.getPage(i)` → `page.render(width, height)` → `pageImage.bytes`
3. Each page becomes an `Image.memory(bytes)` widget
4. All page images are loaded into a `List<Image>` before display

---

## Audio

### audioplayers — `audioplayers: ^5.2.1`

Used in `AudioCubit`. Four stream subscriptions managed:
- `onDurationChanged` — total duration
- `onPositionChanged` — current playback position
- `onPlayerStateChanged` — playing/paused state
- `onPlayerComplete` — playback finished, reset position to zero

**Note:** `just_audio: ^0.9.36` is declared in `pubspec.yaml` but is **not imported or used** anywhere in the Dart code.

---

## Animations & UI

### page_flip — `page_flip: ^0.2.5+1`

Used in `PdfBookFlipLocal`. Displays pre-rendered PDF page images with a 3D book-flip swipe gesture. Applied with a double `Matrix4.rotationY(π)` trick to handle RTL mirroring for Arabic content.

### animate_do — `animate_do: ^4.2.0`

Wrapped in `AppAnimations` class (`lib/core/widgets/animate_do.dart`). Provides:
- `fadeInUp`, `fadeInDown`, `fadeInLeft`, `fadeInRight`
- `slideInUp`, `slideInDown`, `slideInRight`

Used throughout onboarding, home header, story reader header, and category cards.

### flutter_screenutil — `flutter_screenutil: ^5.9.3`

Design size: `375 × 812` (iPhone-based baseline). Used for:
- `isTablet` detection: `ScreenUtil().screenWidth >= 600` (exposed via `context.isTablet` extension)
- Font scaling with `.h` suffix (e.g., `18.h`)
- Dimension scaling in layout widgets

### flutter_staggered_grid_view — `flutter_staggered_grid_view: ^0.7.0`

Used in `StoriesListSection` via `MasonryGridView.count` to display story cover images in a 2-column masonry grid.

### flutter_svg — `flutter_svg: ^2.2.1`

Used in `SocialMediaRow` to render SVG icons for Twitter/X, Instagram, and Facebook.

### skeletonizer — `skeletonizer: ^2.1.3`

Declared as a dependency but not observed in use in any Dart file reviewed. May be unused or planned for future loading states.

---

## Utilities

### url_launcher — `url_launcher: ^6.3.2`

Used in `SocialMediaRow` to open social media profile URLs in the device's default browser or native apps. The Android manifest includes `<queries>` entries for `http`, `https`, `fb`, `instagram`, and `twitter` URI schemes.

### logger — `logger: ^2.5.0`

Wrapped in `AppLogger` (`lib/core/services/app_logger.dart`). All logging is **debug-mode only** (guarded by `kDebugMode`). Methods: `info`, `warn`, `debug`, `error`, `success`.

### path_provider — `any`

Declared as a dependency but not directly used in any reviewed Dart file. May be pulled in transitively.

### device_preview — `^1.3.1`

Wraps the app root in `main.dart`. Allows testing different device sizes during development. **Should be removed or conditionally disabled for production builds.**

---

## Typography

### Tajawal Font (local asset)

Four weights bundled: Light, Regular, Medium, Bold.
Mapped across font weights 100–900 in `pubspec.yaml`.
Set as the global `fontFamily` in `AppTheme`.

---

## Code Quality

### very_good_analysis — `^5.1.0` (dev)

Strict lint ruleset from Very Good Ventures. Custom overrides in `analysis_options.yaml`:
- `always_declare_return_types: true`
- `cancel_subscriptions: true` (enforced for stream subscription cleanup)
- `close_sinks: true`
- `avoid_dynamic_calls: true`
- `unawaited_futures: true`
- Line length and API doc rules relaxed (`lines_longer_than_80_chars: false`, `public_member_api_docs: false`)

---

## Testing (Dev Dependencies — Not Yet Implemented)

| Package | Version | Status |
|---|---|---|
| `flutter_test` | SDK | Declared, no test files written |
| `integration_test` | SDK | Declared, no test files written |
| `bloc_test` | `^10.0.0` | Declared, no test files written |
| `mocktail` | `^1.0.5` | Declared, no test files written |

---

## Summary Table

| Category | Technology | Used |
|---|---|---|
| Framework | Flutter / Dart | ✅ |
| State Management | Cubit (flutter_bloc) | ✅ |
| Navigation | GoRouter | ✅ |
| PDF Rendering | pdfx | ✅ |
| Page Animation | page_flip | ✅ |
| Audio Playback | audioplayers | ✅ |
| Animations | animate_do | ✅ |
| Responsive UI | flutter_screenutil | ✅ |
| Grid Layout | flutter_staggered_grid_view | ✅ |
| SVG Rendering | flutter_svg | ✅ |
| Storage | shared_preferences | ✅ |
| URL Handling | url_launcher | ✅ |
| Logging | logger | ✅ |
| Device Preview | device_preview | ✅ (dev) |
| Linting | very_good_analysis | ✅ |
| just_audio | just_audio | ❌ Declared, not used |
| skeletonizer | skeletonizer | ❌ Likely unused |
