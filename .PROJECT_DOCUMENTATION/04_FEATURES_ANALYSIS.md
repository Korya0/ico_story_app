# 04 — Features Analysis

---

## Feature 1: Onboarding

### Purpose
Introduces the app to first-time users through a 4-page walkthrough. Shown only once. After completion, the user is routed to the home screen and the onboarding flag is saved.

### User Flow
```
App Launch
    ↓
SharedPreferences.getBoolean('showOnboarding')
    ↓
false (first time)           true (returning user)
    ↓                              ↓
OnboardingView             HomeView (skip onboarding)
    ↓
Page 1: Achievement award
Page 2: Browse stories
Page 3: Listen to audio
Page 4: Welcome (Get Started)
    ↓
User taps "ابدأ الآن" (Get Started)
    ↓
SharedPreferences.setBoolean('showOnboarding', true)
    ↓
GoRouter.goNamed('/home')
```

### Files Involved

| File | Role |
|---|---|
| `lib/core/router/app_router.dart` | Initial route selection based on SharedPrefs flag |
| `lib/core/services/shared_pref.dart` | Reads and writes the onboarding flag |
| `lib/features/onboarding/presentation/views/onboarding_view.dart` | Main StatefulWidget — owns PageController, page index state |
| `lib/features/onboarding/presentation/models/onboarding_model.dart` | Static data: 4 page definitions (title, description, image, colors) |
| `lib/features/onboarding/presentation/widgets/onboarding_page_view.dart` | `PageView.builder` wrapping the page widgets |
| `lib/features/onboarding/presentation/widgets/onboarding_widget.dart` | Individual page UI with animated entrance |
| `lib/features/onboarding/presentation/widgets/onboarding_bottom_navigation.dart` | Dots indicator + Next/Get Started buttons |

### Architecture Flow
```
OnboardingView (StatefulWidget)
    ↓ manages PageController & currentPage index
OnboardingPageView (PageView.builder)
    ↓ renders each page
OnboardingWidget (page content + animate_do animations)
    ↓
OnboardingBottomNavigation (dots + action buttons)
    ↓ on "Get Started"
SharedPref.setBoolean('showOnboarding', true)
    ↓
GoRouter.goNamed('/home')
```

**No Cubit used.** Onboarding state (current page index) is managed locally with `setState` in `_OnboardingViewState`.

---

## Feature 2: Home Screen (Category Selection)

### Purpose
Displays the main entry point of the app after onboarding. Shows a welcome header with organisation logos and a 3-category card layout for story selection.

### User Flow
```
HomeView loads
    ↓
BlocProvider creates HomeCubit(repository: HomeRepository())
HomeCubit.getCategories() called immediately
    ↓
HomeLoading state → CircularProgressIndicator
    ↓
HomeCategoriesLoaded(categories) state
    ↓
StoriesCardsWidget renders 3 category cards
(2 cards in a Row + 1 centred below)
    ↓
User taps a card
    ↓
GoRouter.pushNamed('/storiesList', extra: {categoryTitle: category.id})
```

### Files Involved

| File | Role |
|---|---|
| `lib/features/home/presentation/views/home_view.dart` | Screen root, provides `HomeCubit` |
| `lib/features/home/presentation/cubits/home_cubit/home_cubit.dart` | Calls repository, emits states |
| `lib/features/home/presentation/cubits/home_cubit/home_state.dart` | State definitions |
| `lib/features/home/data/repositories/home_repository.dart` | Delegates to `StoryCategoriesList` |
| `lib/features/home/data/datasources/story_categories_list.dart` | Static list of 3 `StoryCategoryModel` |
| `lib/features/home/data/models/story_category_model.dart` | Model: `id`, `title`, `imagePath` |
| `lib/features/home/presentation/widgets/home_view/stories_card_widget.dart` | `BlocBuilder` consuming categories state |
| `lib/features/home/presentation/widgets/home_view/home_story_card.dart` | Individual category card widget |
| `lib/features/home/presentation/widgets/home_view/home_header_section.dart` | Logo + welcome text |
| `lib/features/home/presentation/widgets/home_view/social_button.dart` | Social media section |
| `lib/features/home/presentation/widgets/home_view/social_media_row.dart` | SVG icons + url_launcher |

### Architecture Flow
```
HomeView (UI)
    ↓ BlocProvider
HomeCubit
    ↓ calls
HomeRepository.getCategories()
    ↓ calls
StoryCategoriesList.categories (static List)
    ↓ returns List<StoryCategoryModel>
HomeCubit emits HomeCategoriesLoaded(categories)
    ↓ BlocBuilder
StoriesCardsWidget renders category cards
```

---

## Feature 3: Stories List

### Purpose
Shows all stories in a selected category as a masonry grid of cover images. Tapping a story navigates to the reader screen.

### User Flow
```
User taps a category card on HomeView
    ↓
GoRouter.pushNamed('/storiesList', extra: {categoryTitle: category.id})
    ↓
StoriesListView receives categoryTitle parameter
    ↓
BlocProvider creates HomeCubit(repository: HomeRepository())
HomeCubit.getStoriesForCategory(categoryTitle) called immediately
    ↓
HomeLoading → CircularProgressIndicator
    ↓
HomeStoriesLoaded(stories) state
    ↓
MasonryGridView renders story cover image cards (2 columns)
    ↓
User taps a story card
    ↓
GoRouter.pushNamed('/storyReader', extra: {story: StoryModel, categoryId: categoryTitle})
```

### Files Involved

| File | Role |
|---|---|
| `lib/features/home/presentation/views/stories_list_view.dart` | Screen root, provides `HomeCubit`, uses `CustomScrollView` with `SliverToBoxAdapter` |
| `lib/features/home/presentation/cubits/home_cubit/home_cubit.dart` | `getStoriesForCategory(categoryId)` |
| `lib/features/home/data/repositories/home_repository.dart` | Delegates to `StoryList` |
| `lib/features/home/data/datasources/story_list.dart` | Static lists: 28 char + 20 tarbawia + 20 sira stories |
| `lib/features/home/data/models/story_model.dart` | Model: `id`, `title`, `pdfPath`, `coverImage`, `audioPath?` |
| `lib/features/home/presentation/widgets/stories_list/stories_list_section.dart` | `BlocBuilder` + `MasonryGridView` |
| `lib/features/home/presentation/widgets/stories_list/story_list_card.dart` | Individual story cover card |
| `lib/features/home/presentation/widgets/stories_list/stories_list_header.dart` | Back button + category title |
| `lib/features/home/presentation/utils/home_functions.dart` | `returnTitle(categoryId)` maps ID to Arabic display title |

### Architecture Flow
```
StoriesListView (UI)
    ↓ BlocProvider
HomeCubit
    ↓ calls
HomeRepository.getStoriesForCategory(id)
    ↓ calls
StoryList.getStoriesForCategory(id) (static switch)
    ↓ returns List<StoryModel>
HomeCubit emits HomeStoriesLoaded(stories)
    ↓ BlocBuilder
StoriesListSection → MasonryGridView → StoryListCard
```

---

## Feature 4: Story Reader

### Purpose
The core reading experience. Loads a PDF, renders all pages as images, and displays them with a 3D book-flip animation. Optionally shows an audio player panel for categories that have audio narration.

### User Flow
```
User taps a story card
    ↓
StoryReaderView receives (StoryModel, categoryId)
    ↓
initState():
  - If NOT sira category: AudioCubit initialised, audio loaded
  - AnimationController for wave effect initialised
  - WidgetsBindingObserver registered (lifecycle)
    ↓
PdfBookFlipLocal loads PDF via pdfx
  - All pages rendered to Image.memory list
  - onPdfLoaded callback fires → _isPdfLoaded = true
    ↓
Scaffold builds:
  - StoryReaderHeader (back + title + audio toggle icon)
  - PdfBookFlipLocal (page-flip viewer)
    ↓
If user taps audio toggle icon:
  _showAudioControls toggled → AudioControls panel slides in at bottom
    ↓
AudioControls:
  - Play/Pause button
  - Progress slider (with drag-to-seek)
  - ±10 second skip buttons
  - Time display (current / total)
  - Wave animation while playing
    ↓
App goes to background:
  AudioCubit.handleAppLifecyclePause() → audio pauses
    ↓
User navigates back:
  dispose(): AudioCubit.close(), AnimationController.dispose()
```

### Files Involved

| File | Role |
|---|---|
| `lib/features/home/presentation/views/story_reader_screen.dart` | Main `StatefulWidget` with `WidgetsBindingObserver` |
| `lib/features/home/presentation/cubits/audio_cubit.dart` | Audio state, `AudioPlayer` management, stream subscriptions |
| `lib/features/home/presentation/widgets/story_reader/pdf_book_flip_local.dart` | PDF → images → page_flip widget |
| `lib/features/home/presentation/widgets/story_reader/audio_controls.dart` | Audio player UI with animations |
| `lib/features/home/presentation/widgets/story_reader/story_reader_header.dart` | Header with back button + audio toggle |
| `lib/core/constants/app_keys.dart` | `AppKeys.sira` used to conditionally disable audio |
| `lib/core/constants/app_strings.dart` | Audio type labels (`storyTypeNasheed`, `storyTypeQissa`) |

### Architecture Flow
```
StoryReaderView (StatefulWidget + WidgetsBindingObserver)
    ↓ creates
AudioCubit (if not sira)
    ↓ initialises
AudioPlayer (audioplayers)
  ├─ onDurationChanged stream
  ├─ onPositionChanged stream
  ├─ onPlayerStateChanged stream
  └─ onPlayerComplete stream
         ↓ all emit AudioState updates
BlocProvider<AudioCubit>.value
    ↓
PdfBookFlipLocal
  ├─ PdfDocument.openAsset(pdfPath)     [pdfx]
  ├─ page.render() → Uint8List
  └─ Image.memory(bytes) list → PageFlipWidget [page_flip]
         ↓
AudioControls (BlocBuilder<AudioCubit, AudioState>)
  ├─ _ControlButtons → cubit.togglePlayPause / seekTo
  ├─ _ProgressSlider → cubit.seekTo on drag end
  └─ _TimeDisplay → currentPosition / totalDuration
```

### Conditional Audio Logic
```
categoryId == 'sira'  → no AudioCubit, no audio icon shown
categoryId == 'tarbawia' → label: "الأنشودة"
categoryId == 'char'  → label: "القصة"
```
