# 16 — Skills Mapping

Skill inventory table mapped to actual usage in the ICO Stories codebase.

---

## Complete Skills Table

| Skill | Used | Location / Evidence |
|---|---|---|
| **Flutter** | ✅ Yes | Entire application — `lib/` |
| **Dart 3** | ✅ Yes | `sdk: ^3.8.1` in `pubspec.yaml` |
| **Clean Architecture** | ⚠️ Partial | Feature-based + data layer; no domain/use-case layer |
| **Feature-Based Architecture** | ✅ Yes | `lib/features/onboarding/`, `lib/features/home/` |
| **Repository Pattern** | ✅ Yes | `lib/features/home/data/repositories/home_repository.dart` |
| **Dependency Injection (Manual)** | ✅ Yes | `HomeCubit(repository: HomeRepository())` in views |
| **Dependency Injection (get_it)** | ❌ No | Not used |
| **SOLID Principles** | ⚠️ Partial | SRP ✅, OCP ⚠️, LSP ✅, ISP ❌, DIP ⚠️ |
| **Cubit** | ✅ Yes | `HomeCubit`, `AudioCubit` — `flutter_bloc: ^9.0.0` |
| **BLoC (with Events)** | ❌ No | Cubit used exclusively |
| **Provider** | ❌ No | Not used |
| **Riverpod** | ❌ No | Not used |
| **GetX** | ❌ No | Not used |
| **BlocObserver** | ✅ Yes | `lib/core/services/app_bloc_observer.dart` |
| **GoRouter** | ✅ Yes | `lib/core/router/app_router.dart` — `go_router: ^16.2.1` |
| **Named Routes** | ✅ Yes | `AppRoutes` class, `pushNamed()` calls |
| **Route Guards** | ⚠️ Partial | Initial route selected based on SharedPrefs flag (onboarding check) |
| **REST APIs** | ❌ No | No HTTP calls |
| **GraphQL** | ❌ No | Not used |
| **WebSockets** | ❌ No | Not used |
| **Dio** | ❌ No | Not used |
| **Retrofit** | ❌ No | Not used |
| **Firebase** | ❌ No | Not used |
| **Supabase** | ❌ No | Not used |
| **Hive** | ❌ No | Not used |
| **SharedPreferences** | ✅ Yes | `lib/core/services/shared_pref.dart` — onboarding flag |
| **Secure Storage** | ❌ No | Not used (not needed — no sensitive data) |
| **SQLite** | ❌ No | Not used |
| **Responsive UI** | ✅ Yes | `flutter_screenutil`, `context.isTablet` extension |
| **RTL / Arabic Locale** | ✅ Yes | `Directionality(RTL)`, `Locale('ar', 'EG')` in `main.dart` |
| **Localisation (intl / .arb)** | ❌ No | Strings hardcoded in `AppStrings` — single language |
| **Accessibility** | ❌ No | No `Semantics` widgets, no screen reader support implemented |
| **Animations** | ✅ Yes | `animate_do` (FadeIn, SlideIn), `AnimationController` (wave, scale) |
| **3D Transformations** | ✅ Yes | `Matrix4.rotationY(π)` double-flip in `pdf_book_flip_local.dart` |
| **Page Flip Animation** | ✅ Yes | `page_flip: ^0.2.5+1` in `pdf_book_flip_local.dart` |
| **PDF Rendering** | ✅ Yes | `pdfx: ^2.9.2` — render pages to `Image.memory` |
| **Audio Playback** | ✅ Yes | `audioplayers: ^5.2.1` in `AudioCubit` |
| **Stream Management** | ✅ Yes | 4 `StreamSubscription` objects in `AudioCubit`, cancelled in `close()` |
| **App Lifecycle Handling** | ✅ Yes | `WidgetsBindingObserver` in `StoryReaderView` |
| **System UI Control** | ✅ Yes | `SystemChrome.setEnabledSystemUIMode()` in `PdfBookFlipLocal` |
| **SVG Rendering** | ✅ Yes | `flutter_svg: ^2.2.1` in `social_media_row.dart` |
| **Staggered Grid** | ✅ Yes | `flutter_staggered_grid_view` — `MasonryGridView` in `stories_list_section.dart` |
| **URL Launching** | ✅ Yes | `url_launcher: ^6.3.2` in `social_media_row.dart` |
| **Structured Logging** | ✅ Yes | `AppLogger` wrapping `logger: ^2.5.0`, debug-only |
| **Unit Testing** | ❌ No | Dependencies declared, no tests written |
| **Widget Testing** | ❌ No | Dependencies declared, no tests written |
| **Integration Testing** | ❌ No | Dependencies declared, no tests written |
| **bloc_test** | ❌ No | Declared but not used |
| **mocktail** | ❌ No | Declared but not used |
| **Git** | ✅ Yes | GitHub repository (`github.com/Korya0/ico_story_app`), `develop` branch |
| **GitHub Actions** | ❌ No | No `.github/workflows/` directory |
| **Fastlane** | ❌ No | Not configured |
| **Shorebird** | ❌ No | Not configured |
| **CI/CD** | ❌ No | No pipeline configured |
| **Linting (very_good_analysis)** | ✅ Yes | `analysis_options.yaml`, `dev_dependencies` |
| **Code Obfuscation** | ❌ No | No build configuration found |
| **DevicePreview** | ✅ Yes (dev) | `main.dart` — should be guarded for production |
| **Immutable State** | ✅ Yes | `AudioState.copyWith()` pattern |
| **Context Extensions** | ✅ Yes | `context.isTablet` — `lib/core/utils/context_extension.dart` |
| **Singleton Pattern** | ✅ Yes | `SharedPref` — factory constructor singleton |
| **Static Data Sources** | ✅ Yes | `StoryList`, `StoryCategoriesList` — hardcoded Dart constants |
| **Asset Bundling** | ✅ Yes | PDFs, MP3s, images, SVGs, fonts in `assets/` |
| **Custom Fonts** | ✅ Yes | Tajawal (4 weights) — `assets/fonts/` |
| **Haptic Feedback** | ✅ Yes | `HapticFeedback.lightImpact()` / `.mediumImpact()` in `AudioControls` |

---

## Skills Summary by Category

### Strong (Used, Working, Production-Ready)
- Flutter / Dart
- Cubit state management
- GoRouter navigation
- Repository pattern
- Feature-based architecture
- Responsive UI (phone + tablet)
- Audio stream management
- PDF rendering pipeline
- Custom animations (animate_do + AnimationController)
- RTL/Arabic layout
- Structured logging
- Linting/code quality (very_good_analysis)

### Partial (Used but with Gaps)
- Clean Architecture (data layer present, no domain layer)
- SOLID principles (SRP, LSP good; DIP needs abstract interfaces)
- Route guards (basic initial-route logic only)

### Infrastructure (Not Implemented — Known Gap)
- Unit/Widget/Integration Testing
- CI/CD pipeline
- Code obfuscation
- Crash reporting (Firebase Crashlytics or Sentry)
- Localisation (multi-language support)
