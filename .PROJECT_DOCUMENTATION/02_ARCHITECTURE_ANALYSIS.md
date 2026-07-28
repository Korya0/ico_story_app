# 02 — Architecture Analysis

---

## Folder Structure

```
lib/
├── main.dart                          # Entry point, app bootstrap
├── core/                              # Shared, feature-agnostic utilities
│   ├── constants/
│   │   ├── app_assets.dart            # Asset path constants
│   │   ├── app_constant.dart          # Locale/font constants
│   │   ├── app_keys.dart              # String keys for SharedPrefs & routing extras
│   │   └── app_strings.dart           # All UI text strings (Arabic)
│   ├── router/
│   │   ├── app_router.dart            # GoRouter configuration & initial route logic
│   │   ├── app_routes.dart            # Route path constants
│   │   └── app_transitions.dart       # Page transition helper
│   ├── services/
│   │   ├── app_bloc_observer.dart     # Global BLoC lifecycle logger
│   │   ├── app_initializer.dart       # App startup sequence
│   │   ├── app_logger.dart            # Debug-only structured logging
│   │   ├── pref_keys.dart             # SharedPreferences key aliases
│   │   └── shared_pref.dart           # SharedPreferences singleton wrapper
│   ├── style/
│   │   ├── app_colors.dart            # Global color palette
│   │   └── app_theme.dart             # MaterialApp ThemeData
│   ├── utils/
│   │   └── context_extension.dart     # BuildContext extensions (isTablet)
│   └── widgets/
│       ├── animate_do.dart            # animate_do wrapper (AppAnimations)
│       ├── custom_back_button.dart    # Reusable back button
│       ├── custom_button.dart         # Reusable button widget
│       ├── custom_icon_cackground.dart # Icon with background container
│       ├── custom_text.dart           # Responsive text widget
│       └── gap.dart                   # SizedBox shorthand
│
└── features/
    ├── onboarding/
    │   └── presentation/
    │       ├── models/
    │       │   └── onboarding_model.dart
    │       ├── views/
    │       │   └── onboarding_view.dart
    │       └── widgets/
    │           ├── onboarding_bottom_navigation.dart
    │           ├── onboarding_page_view.dart
    │           └── onboarding_widget.dart
    │
    └── home/
        ├── data/
        │   ├── datasources/
        │   │   ├── story_categories_list.dart
        │   │   └── story_list.dart
        │   ├── models/
        │   │   ├── story_category_model.dart
        │   │   └── story_model.dart
        │   └── repositories/
        │       └── home_repository.dart
        └── presentation/
            ├── cubits/
            │   ├── audio_cubit.dart
            │   └── home_cubit/
            │       ├── home_cubit.dart
            │       └── home_state.dart
            ├── utils/
            │   └── home_functions.dart
            ├── views/
            │   ├── home_view.dart
            │   ├── stories_list_view.dart
            │   └── story_reader_screen.dart
            └── widgets/
                ├── common/
                │   └── custom_card_background.dart
                ├── home_view/
                │   ├── home_header_section.dart
                │   ├── home_story_card.dart
                │   ├── social_button.dart
                │   └── social_media_row.dart
                ├── stories_list/
                │   ├── stories_list_header.dart
                │   ├── stories_list_section.dart
                │   └── story_list_card.dart
                └── story_reader/
                    ├── audio_controls.dart
                    ├── pdf_book_flip_local.dart
                    └── story_reader_header.dart
```

---

## Architecture Pattern

### What is Used: Feature-Based Architecture with a Partial Data Layer

The project applies a **feature-based folder structure** where each feature (`onboarding`, `home`) owns its own presentation layer. The `home` feature also has a `data` layer with models, datasources, and a repository. However, there is **no domain layer** — no use cases, no abstract repository interfaces, and no dependency inversion.

```
┌─────────────────────────────────┐
│         Presentation Layer       │
│   Views → Cubits → Widgets       │
│   (flutter_bloc, GoRouter)       │
├─────────────────────────────────┤
│            Data Layer            │
│   Repository → DataSources →     │
│         Models (static)          │
├─────────────────────────────────┤
│           Core Layer             │
│  Constants, Services, Widgets,   │
│  Router, Style, Utils            │
└─────────────────────────────────┘
```

**Missing layer compared to full Clean Architecture:**
```
Domain Layer (NOT PRESENT):
  - No abstract Repository interfaces
  - No UseCases / Interactors
  - No Entity separation from Model
```

---

## Patterns Identified

### Feature-Based Architecture ✅
Each feature lives in its own folder under `lib/features/`. The `onboarding` and `home` features are independent modules. This enables easy navigation and future scaling.

### Repository Pattern ✅ (Partial)
`HomeRepository` (`lib/features/home/data/repositories/home_repository.dart`) acts as a data access abstraction between the Cubit and the data sources. However, it is a **concrete class, not an abstract interface**, so it cannot be easily swapped or mocked through dependency injection.

```dart
// home_repository.dart — concrete class only, no abstract interface
class HomeRepository {
  List<StoryCategoryModel> getCategories() =>
      StoryCategoriesList.categories;
  List<StoryModel> getStoriesForCategory(String categoryId) =>
      StoryList.getStoriesForCategory(categoryId);
}
```

### Dependency Injection ✅ (Manual / Partial)
`HomeRepository` is instantiated manually in the view and injected into `HomeCubit` via constructor:

```dart
// home_view.dart
BlocProvider(
  create: (context) => HomeCubit(repository: HomeRepository())..getCategories(),
  ...
)
```

There is no service locator (e.g., `get_it`) or code-generated DI. The injection is manual and repeated at each usage site.

### Clean Architecture ❌ (Not Fully Applied)
The README states "Clean Architecture" but the implementation does not include a domain layer. There are no use cases, no abstract interfaces, and the data models are used directly in the presentation layer without entity mapping.

---

## Layers Responsibility

| Layer | Responsibility | Files |
|---|---|---|
| **Presentation** | UI rendering, state consumption, user interactions | `views/`, `widgets/`, `cubits/` |
| **Data** | Data models, static data sources, repository | `models/`, `datasources/`, `repositories/` |
| **Core** | App-wide utilities, routing, services, design system | `core/` |

### Cubit Responsibility
- `HomeCubit`: loads story categories and stories list from the repository, emits state
- `AudioCubit`: manages `AudioPlayer` lifecycle, streams position/duration, exposes play/pause/seek

### Data Source Responsibility
- `StoryList`: static registry of all 68 `StoryModel` objects (asset paths hardcoded)
- `StoryCategoriesList`: static list of 3 `StoryCategoryModel` objects

---

## Why This Architecture Was Likely Chosen

1. **Simplicity**: There is no backend API. All data is local and static. A full Clean Architecture with UseCases and abstract interfaces would add unnecessary boilerplate for a purely local-data app.
2. **Speed of delivery**: Client projects often require faster delivery. Feature-based structure with a repository layer provides enough separation without over-engineering.
3. **Flutter BLoC convention**: The BlocProvider pattern naturally encourages scoping state to screens/features, which aligns with feature-based folder organisation.

---

## Advantages of This Architecture

- Clear separation between UI and data access via the repository layer
- Feature isolation makes it easy to find code by business domain
- Cubit is lightweight and readable for simple synchronous data loading
- Core layer provides reusable widgets, constants, and services without feature coupling
- AppBlocObserver provides global state change visibility during development

---

## Possible Improvements

| Improvement | Reason |
|---|---|
| Add abstract `IHomeRepository` interface | Enables proper mocking in tests and true dependency inversion |
| Introduce a Domain/UseCase layer | Moves business logic (e.g., `getStoriesForCategory`) out of the repository |
| Use a DI container (`get_it`) | Avoids manual `HomeRepository()` instantiation at each BlocProvider site |
| Separate `Entity` from `Model` | Currently `StoryModel` is used directly in the presentation layer |
| Remove `DevicePreview` from production builds | It is currently always active in `main.dart` |
| Move `just_audio` to actual use or remove from `pubspec.yaml` | It is declared but never imported or used in any Dart file |
