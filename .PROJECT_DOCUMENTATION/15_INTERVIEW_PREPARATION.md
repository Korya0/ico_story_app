# 15 — Interview Preparation

Technical questions an interviewer might ask about this project, with precise answers based on the actual code.

---

## Architecture Questions

**Q1: What architecture did you use in this project?**

I used a **feature-based architecture** with a **data layer** including a Repository pattern. Each feature (`onboarding`, `home`) has its own `presentation/` folder. The `home` feature additionally has a `data/` folder with models, static data sources, and a repository. There is a shared `core/` layer for constants, services, router, and reusable widgets.

It's important to be honest: this is not full Clean Architecture. There is no domain layer, no use cases, and no abstract repository interfaces. The data models are used directly in the presentation layer.

---

**Q2: Why did you choose Cubit over full BLoC or other state management solutions?**

The app's state operations are simple and synchronous — load a list from static data, emit a state. There are no complex event chains, no debouncing, no event transformers needed. Cubit is a simplified version of BLoC that eliminates the `Event` boilerplate while retaining structured state emission and full BlocObserver visibility. It was the right tool for this scope. If the app grew to need event-level replay or complex async event handling, I'd migrate to full BLoC.

---

**Q3: How does your navigation work, and how do you pass data between routes?**

I used `GoRouter` with 4 named routes. Data is passed via the `extra` parameter as a `Map<String, dynamic>`. For example, navigating to the story reader:

```dart
context.pushNamed(
  AppRoutes.storyReader,
  extra: {'story': story, 'categoryId': categoryTitle},
);
```

At the destination, the extras are cast:
```dart
final extras = state.extra! as Map<String, dynamic>;
final story = extras['story'] as StoryModel;
```

The tradeoff is that this extra casting is untyped and can fail at runtime if a key is missing. A better approach would be a type-safe route with code generation (`auto_route`).

---

**Q4: How did you handle app startup and initialisation?**

`AppInitializer.initialize()` is called before `runApp()`. It:
1. Ensures Flutter binding is initialised
2. Sets `AppBlocObserver` as the global Bloc observer
3. Locks screen orientation to portrait
4. Initialises `SharedPreferences`

This gives a clean, sequential async initialisation before the widget tree is built.

---

## State Management Questions

**Q5: Walk me through your AudioCubit implementation.**

`AudioCubit` owns an `AudioPlayer` instance and manages 4 `StreamSubscription` objects:
- `onDurationChanged` → emits `state.copyWith(totalDuration: ...)`
- `onPositionChanged` → emits `state.copyWith(currentPosition: ...)`
- `onPlayerStateChanged` → emits `state.copyWith(isPlaying: ...)`
- `onPlayerComplete` → resets position to zero

`AudioState` is an immutable class with a `copyWith` method. The `progress` getter derives the 0.0–1.0 slider value from `currentPosition / totalDuration`.

On `close()`, all 4 subscriptions are cancelled before calling `super.close()` and `_audioPlayer.dispose()`. This is critical to prevent stream leaks.

---

**Q6: How does the audio player handle app backgrounding?**

`StoryReaderView` implements `WidgetsBindingObserver` and overrides `didChangeAppLifecycleState`. When the app enters `paused`, `inactive`, or `detached` state, it calls `_audioCubit?.handleAppLifecyclePause()`, which pauses the player if it's currently playing. This is the standard Flutter pattern for handling audio in the foreground only.

---

**Q7: How is the HomeCubit provided and how does the same Cubit class serve two different screens?**

`HomeCubit` is created fresh at each screen via `BlocProvider`:
- `HomeView` creates `HomeCubit` and calls `getCategories()`
- `StoriesListView` creates a new `HomeCubit` and calls `getStoriesForCategory(categoryTitle)`

They're separate instances, not shared. This is intentional — each screen needs its own state. The same Cubit class is reused because the data loading pattern is identical (loading → loaded/error), and the `HomeRepository` exposes both operations.

---

## PDF & Animation Questions

**Q8: How did you implement the PDF book-flip for Arabic content?**

This was the most technically interesting challenge. The `page_flip` package assumes left-to-right page turning. For Arabic, we need the opposite. I used a double `Matrix4.rotationY(π)` technique:

1. The outer `Transform` around the entire `PageFlipWidget` flips it horizontally — this reverses the page-turn direction to right-to-left
2. Each individual page has an inner `Transform` with the same rotation — this corrects the content back to the right orientation (without this, text would be mirrored)

The result: correct Arabic right-to-left page turning with unmirrored content.

---

**Q9: Why did you choose to render all PDF pages at once instead of lazily?**

The `page_flip` widget needs all pages as `Widget` objects upfront — it doesn't support lazy loading. This was a constraint of the library, not a deliberate design choice. The tradeoff is that for large PDFs (some are up to 79MB), all pages are held in memory simultaneously. A future improvement would be either finding a lazy-supporting page-flip library or implementing a virtual scroll that pre-renders only nearby pages.

---

## Performance Questions

**Q10: What are the main performance risks in this app?**

The biggest risk is memory pressure from PDF rendering. Every page is rendered to a `Uint8List` and wrapped in an `Image.memory` widget, all in memory at once. For the largest PDFs (79MB PDF file → rendered images that could be significantly larger), this can cause OOM on low-end Android devices.

The second concern is the cover image sizes. Some `.png` covers for the `char` and `sira` categories are 5–13MB. The recommended fix is converting all cover images to `.webp` (the `tarbawia` category already uses `.webp` at 19–42KB each).

---

**Q11: The `AudioControls` BlocBuilder rebuilds on every position stream event. How would you optimise this?**

I'd use `BlocSelector` to rebuild only the widgets that depend on changing data:

```dart
// Only rebuilds when currentPosition changes
BlocSelector<AudioCubit, AudioState, Duration>(
  selector: (state) => state.currentPosition,
  builder: (context, position) => _TimeDisplay(currentPosition: position),
)
```

The play button, which only depends on `isPlaying`, would rebuild much less frequently than the time display.

---

## Error Handling Questions

**Q12: How does your app handle errors when loading stories?**

`HomeCubit` wraps both operations in `try/catch`. On exception, it emits `HomeError(message)`. However, I'll be honest: the UI currently does not render the `HomeError` state — it falls through to an empty `SizedBox`. This is a known gap. In a production version, the `BlocBuilder` should explicitly handle `HomeError` with a user-visible message and a retry button.

---

## Testing Questions

**Q13: There are no tests in this project. How would you approach writing them?**

I'd start with unit tests for `HomeCubit` using `bloc_test` and `mocktail`. The first step is extracting an `IHomeRepository` abstract interface so the concrete class can be properly mocked. Then I'd test all state transitions: loading → loaded, loading → error, and correct data counts per category.

For `AudioCubit`, I'd abstract `AudioPlayer` behind a thin interface to enable mock injection. After unit tests, I'd add widget tests for the key `BlocBuilder` state transitions in `StoriesCardsWidget` and `AudioControls`. Integration tests would cover the full onboarding flow and story navigation.

---

## Code Quality Questions

**Q14: Why does the project have `just_audio` in pubspec.yaml but it's never imported in any Dart file?**

It's a leftover from an earlier evaluation phase. During development, I likely experimented with both `audioplayers` and `just_audio` before settling on `audioplayers`. Once `audioplayers` was chosen, `just_audio` should have been removed from `pubspec.yaml`. It increases APK size unnecessarily and is technically debt.

---

**Q15: What would you change if you were to refactor this project?**

The top three changes I'd make:
1. **Extract `IHomeRepository` interface** — enables proper mocking and follows DIP
2. **Remove `DevicePreview` from production** — guard it with `kReleaseMode`
3. **Implement lazy PDF page loading** — render only current ± 2 pages to reduce memory usage on large PDFs

And the quick wins: remove `just_audio`, remove unused storage permissions, convert all `.png` covers to `.webp`, change package name from `com.example`.
