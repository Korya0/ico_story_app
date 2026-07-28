# 07 — Error Handling

---

## Overview

Error handling in ICO Stories is minimal by design, reflecting the fact that the app has no network layer and all data is local. The main error paths are:

1. Cubit-level try/catch for data loading
2. Audio player load/stream error handling in `AudioCubit`
3. PDF rendering error catch in `PdfBookFlipLocal`
4. URL launch failure handling in `SocialMediaRow`

There are no HTTP errors, no authentication errors, no serialisation errors (data is pure Dart objects), and no database errors.

---

## 1. Cubit Error Handling (HomeCubit)

**File:** `lib/features/home/presentation/cubits/home_cubit/home_cubit.dart`

`HomeCubit` wraps both operations in `try/catch`:

```dart
void getCategories() {
  try {
    emit(HomeLoading());
    final categories = repository.getCategories();
    emit(HomeCategoriesLoaded(categories));
  } catch (e) {
    emit(HomeError(e.toString()));
  }
}

void getStoriesForCategory(String categoryId) {
  try {
    emit(HomeLoading());
    final stories = repository.getStoriesForCategory(categoryId);
    emit(HomeStoriesLoaded(stories));
  } catch (e) {
    emit(HomeError(e.toString()));
  }
}
```

### State Flow

```
HomeCubit.getCategories()
    ↓
try block
    ↓ success
HomeCategoriesLoaded(categories) → UI renders list
    ↓ exception
HomeError(message) → UI could render error message
```

### HomeError State Definition

```dart
class HomeError extends HomeState {
  HomeError(this.message);
  final String message;
}
```

### UI Handling of HomeError

**Limitation:** The UI in `StoriesCardsWidget` and `StoriesListSection` only handle `HomeLoading` and the success states. The `HomeError` state falls through to `return const SizedBox()` — the error is **silently swallowed** and the user sees a blank screen.

```dart
// stories_card_widget.dart
if (state is HomeLoading) {
  return const Center(child: CircularProgressIndicator());
} else if (state is HomeCategoriesLoaded) {
  // render cards
}
// HomeError → falls to implicit else → SizedBox() — no error message shown
return const SizedBox();
```

**This is a gap**: in production, `HomeError` should render a user-visible error message or retry option.

---

## 2. Audio Error Handling (AudioCubit)

**File:** `lib/features/home/presentation/cubits/audio_cubit.dart`

`AudioCubit.AudioState` includes an optional `error` field:

```dart
class AudioState {
  const AudioState({
    // ...
    this.error,
  });
  final String? error;
}
```

The `_loadAudio` method catches exceptions and emits an error state:

```dart
Future<void> _loadAudio() async {
  try {
    await _audioPlayer.setSource(AssetSource(audioAssetPath));
  } catch (e) {
    AppLogger.error('AudioCubit: Failed to load audio', error: e);
    emit(state.copyWith(
      isLoading: false,
      error: 'Audio loading error: $e',
    ));
  }
}
```

### UI Handling of Audio Error

**Limitation:** `AudioControls` (`BlocBuilder<AudioCubit, AudioState>`) does not check `state.error`. If audio fails to load, `state.isLoading` will become `false` and `state.isPlaying` will remain `false`, so the play button will appear but tapping it will have no effect. The error string is logged to console but **not shown to the user**.

---

## 3. PDF Loading Error Handling

**File:** `lib/features/home/presentation/widgets/story_reader/pdf_book_flip_local.dart`

```dart
Future<void> _loadPages() async {
  try {
    final doc = await PdfDocument.openAsset(widget.pdfPath);
    for (var i = 1; i <= doc.pagesCount; i++) {
      // render pages...
    }
    if (mounted) {
      setState(() { _isLoading = false; });
      widget.onPdfLoaded?.call();
    }
  } catch (e) {
    debugPrint('Error loading PDF: $e');
    if (mounted) {
      setState(() { _isLoading = false; });
    }
  }
}
```

### Handling
- On error: `_isLoading` is set to `false` and the error is printed to console
- `pages` list will be empty, so `PdfBookFlipLocal.build()` returns `SizedBox.shrink()`
- `widget.onPdfLoaded` is **not called** on error — the parent `StoryReaderView` will never set `_isPdfLoaded = true`, meaning the header is never shown and the loading indicator remains visible permanently

**This is a gap**: the user sees an infinite loading spinner with no explanation if the PDF fails to load.

---

## 4. URL Launch Error Handling

**File:** `lib/features/home/presentation/widgets/home_view/social_media_row.dart`

```dart
Future<void> _openUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    debugPrint('Could not launch $url');
  }
}
```

### Handling
- `canLaunchUrl` is checked before launching — safe guard against crashes
- On failure: message is printed to debug console; no UI feedback to user

---

## 5. AppBlocObserver Error Logging

**File:** `lib/core/services/app_bloc_observer.dart`

All Cubit/BLoC errors are intercepted globally:

```dart
@override
void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
  AppLogger.error(
    '[BlocError] ${bloc.runtimeType}',
    error: error,
    stackTrace: stackTrace,
  );
  super.onError(bloc, error, stackTrace);
}
```

This provides a global safety net for any unhandled Cubit exception — it will be logged with a full stack trace in debug mode.

---

## 6. AppLogger (Debug-Only Logging)

**File:** `lib/core/services/app_logger.dart`

All error logging is **debug-mode only** (`kDebugMode` guard):

```dart
static void error(String message, {Object? error, StackTrace? stackTrace}) {
  if (kDebugMode) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
```

**Implication:** In release/production builds, errors are completely silent. There is no crash reporting (e.g., Firebase Crashlytics, Sentry) integrated. If a production user encounters an error, it goes undetected.

---

## Summary of Error Handling Gaps

| Area | Current Handling | Gap |
|---|---|---|
| `HomeError` state in UI | Silent `SizedBox()` | Should show error message + retry button |
| Audio load failure | Logged, `error` field in state | `AudioControls` does not display the error |
| PDF load failure | Debug print, spinner stays | Should show error message and back button |
| URL launch failure | Debug print only | Could show a Snackbar |
| Production crash reporting | None | No Crashlytics/Sentry integration |

---

## Complete Error Flow (What Exists)

```
Exception thrown anywhere in Cubit
    ↓
catch (e) in HomeCubit / AudioCubit
    ↓
AppLogger.error(...) — debug console only
    ↓
HomeError(message) / AudioState(error: message) emitted
    ↓
AppBlocObserver.onError() — additional global log
    ↓
UI BlocBuilder — falls through to SizedBox / no visual feedback
```
