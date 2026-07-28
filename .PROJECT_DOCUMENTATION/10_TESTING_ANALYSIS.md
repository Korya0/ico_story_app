# 10 — Testing Analysis

---

## Current Test Status

**No tests have been written.** The project declares all necessary testing dependencies but the `test/` directory does not exist and no `.dart` test files are present anywhere in the project.

---

## Declared Test Dependencies (pubspec.yaml)

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  bloc_test: ^10.0.0
  mocktail: ^1.0.5
```

All four testing packages are present and ready to use. The infrastructure is prepared but unused.

---

## What Should Be Tested

### Unit Tests

#### HomeCubit
The highest-priority unit test target. `HomeCubit` is stateful and uses a repository dependency.

**Test cases:**
- `getCategories()` emits `[HomeLoading, HomeCategoriesLoaded]` with correct list
- `getStoriesForCategory('char')` emits `[HomeLoading, HomeStoriesLoaded]` with 28 stories
- `getStoriesForCategory('tarbawia')` emits `[HomeLoading, HomeStoriesLoaded]` with 20 stories
- `getStoriesForCategory('sira')` emits `[HomeLoading, HomeStoriesLoaded]` with 20 stories
- When repository throws, `getCategories()` emits `[HomeLoading, HomeError]`

**Using `bloc_test` + `mocktail`:**
```dart
// Example test structure
class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  group('HomeCubit', () {
    late HomeCubit cubit;
    late MockHomeRepository mockRepository;

    setUp(() {
      mockRepository = MockHomeRepository();
      cubit = HomeCubit(repository: mockRepository);
    });

    tearDown(() => cubit.close());

    blocTest<HomeCubit, HomeState>(
      'emits [HomeLoading, HomeCategoriesLoaded] when getCategories succeeds',
      build: () {
        when(() => mockRepository.getCategories()).thenReturn(fakeCategories);
        return cubit;
      },
      act: (cubit) => cubit.getCategories(),
      expect: () => [
        isA<HomeLoading>(),
        isA<HomeCategoriesLoaded>(),
      ],
    );
  });
}
```

**Blocker:** `HomeRepository` is a concrete class with no abstract interface. Mocking it with `mocktail` requires:
1. Either extracting an `IHomeRepository` abstract class
2. Or using `mocktail`'s ability to mock concrete classes directly (supported in newer versions)

#### AudioCubit
Tests for audio state management:
- Initial state has `isLoading: true`, `isPlaying: false`
- `togglePlayPause()` when paused calls `_audioPlayer.resume()`
- `togglePlayPause()` when playing calls `_audioPlayer.pause()`
- `seekTo(Duration)` calls `_audioPlayer.seek(position)`
- `handleAppLifecyclePause()` calls `pause()` when `isPlaying: true`
- `close()` cancels all subscriptions

**Challenge:** `AudioPlayer` (from `audioplayers`) is a concrete class. Testing requires either:
- Mocking the `AudioPlayer` class with `mocktail`
- Creating a thin wrapper/interface around `AudioPlayer` for easier mocking

#### HomeRepository
```dart
// Direct unit test (no mocking needed — tests static data)
test('getCategories returns 3 categories', () {
  final repo = HomeRepository();
  final categories = repo.getCategories();
  expect(categories.length, 3);
});

test('getStoriesForCategory char returns 28 stories', () {
  final repo = HomeRepository();
  expect(repo.getStoriesForCategory('char').length, 28);
});
```

#### StoryList (Data Source)
```dart
test('char stories have Arabic letter IDs', () {
  final stories = StoryList.getCharStories;
  expect(stories.first.id, 'أ');
  expect(stories.last.id, 'ي');
});

test('sira stories have no audioPath', () {
  final siraStories = StoryList.getSiraStories;
  expect(siraStories.every((s) => s.audioPath == null), isTrue);
});
```

---

### Widget Tests

#### OnboardingView
- Renders first page (achievement) on load
- "تخطي" (skip) button is visible and navigates to last page
- "التالي" (next) button advances pages
- "ابدأ الآن" (start now) button is visible on last page
- `SharedPref.setBoolean` is called when "ابدأ الآن" is tapped

#### StoriesCardsWidget
- Shows `CircularProgressIndicator` when `HomeLoading`
- Shows 3 category cards when `HomeCategoriesLoaded`
- Returns `SizedBox` when `HomeError`

#### AudioControls
- Shows `CircularProgressIndicator` inside play button when `isLoading: true`
- Shows pause icon when `isPlaying: true`
- Shows play icon when `isPlaying: false`
- Tapping play button calls `cubit.togglePlayPause()`
- Dragging slider does not call `seekTo` until release

---

### Integration Tests

Given no CI/CD, integration tests would run manually:

- **Full onboarding flow:** Launch → skip → verify HomeView is shown → restart → verify onboarding is skipped
- **Story navigation flow:** HomeView → tap category → StoriesListView → tap story → StoryReaderView loads PDF
- **Audio playback:** Open `char` story → tap audio toggle → audio starts → pause works → seek works → close screen → audio stops

---

## Testing Strategy (Recommended)

```
Test Pyramid for ico_story_app:

         ┌──────────────┐
         │ Integration  │  2–3 critical user flows
         │     Tests    │
         ├──────────────┤
         │   Widget     │  Key state transitions in BlocBuilders
         │    Tests     │
         ├──────────────┤
         │    Unit      │  HomeCubit, AudioCubit, Repository,
         │    Tests     │  StoryList data integrity
         └──────────────┘
```

### Priority Order
1. `HomeCubit` unit tests (highest value, easiest to implement)
2. `HomeRepository` / `StoryList` data integrity tests
3. `AudioCubit` unit tests (requires `AudioPlayer` abstraction)
4. Widget tests for `StoriesCardsWidget`
5. Widget tests for `AudioControls`
6. Integration test for onboarding flow

---

## Mocking Approach (Recommended)

Using `mocktail`:

```dart
// For HomeRepository (after extracting interface):
abstract class IHomeRepository {
  List<StoryCategoryModel> getCategories();
  List<StoryModel> getStoriesForCategory(String categoryId);
}

class MockHomeRepository extends Mock implements IHomeRepository {}
```

For `SharedPref`, a similar thin interface extraction or direct test with `SharedPreferences.setMockInitialValues({})` (provided by the `shared_preferences` test package) would work.

---

## Coverage Goal (Recommended)

Given the small codebase:
- Unit test target: **80%+ coverage** for `cubits/` and `data/`
- Widget test target: **key state transitions** in `BlocBuilder` widgets
- Integration test: **critical user paths** only
