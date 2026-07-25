# 📁 ICO Story App - Project Structure

```
ico_story_app/
│
├── .agents/                          # AI agent skills
│   └── skills/
│       └── code_refactor/
│           └── SKILL.md
│
├── .gitignore
├── .metadata
├── analysis_options.yaml
├── pubspec.yaml                      # Project config & dependencies
├── README.md
├── PROJECT_STRUCTURE.md              # This file
│
├── assets/
│   ├── audio/
│   │   ├── char/                     # Arabic letter stories audio
│   │   └── tarbawia/                 # Educational stories audio
│   │
│   ├── fonts/
│   │   ├── Tajawal-Bold.ttf
│   │   ├── Tajawal-Light.ttf
│   │   ├── Tajawal-Medium.ttf
│   │   └── Tajawal-Regular.ttf
│   │
│   ├── images/
│   │   ├── app/                      # App logos (icologo, ICOappstore, directaid)
│   │   ├── covers/
│   │   │   ├── char/                 # Cover images: Arabic letter stories
│   │   │   ├── sira/                 # Cover images: Prophet biography (sira)
│   │   │   └── tarbawia/             # Cover images: Educational stories
│   │   ├── labels/                   # Category label images
│   │   ├── onboarding/               # Onboarding screen images
│   │   └── social/                   # Social media SVG icons
│   │
│   └── pdf/
│       ├── char/                     # Arabic letter stories PDFs
│       ├── sira/                     # Prophet biography (sira) PDFs
│       └── tarbawia/                 # Educational stories PDFs
│
├── android/                          # Android platform config
│   ├── app/
│   │   ├── build.gradle.kts
│   │   └── src/
│   │       ├── debug/
│   │       ├── main/
│   │       │   ├── AndroidManifest.xml
│   │       │   ├── kotlin/com/example/ico_story_app/MainActivity.kt
│   │       │   └── res/              # Android resources
│   │       └── profile/
│   │           └── AndroidManifest.xml
│   ├── build.gradle.kts
│   ├── gradle/
│   │   └── wrapper/
│   │       └── gradle-wrapper.properties
│   ├── gradle.properties
│   └── settings.gradle.kts
│
├── ios/                              # iOS platform config
├── web/                              # Web platform config
│   ├── index.html
│   └── manifest.json
│
├── test/                             # Tests
│   └── widget_test.dart
│
└── lib/                              # 📦 Main application code
    ├── main.dart                     # App entry point
    │
    ├── core/                         # 🏗️ Shared core layer
    │   ├── constants/
    │   │   ├── app_assets.dart       # Asset path constants
    │   │   ├── app_constant.dart     # General app constants
    │   │   ├── app_keys.dart         # Key identifiers (shared prefs, categories)
    │   │   └── app_strings.dart      # Localized strings (Arabic)
    │   │
    │   ├── router/
    │   │   ├── app_router.dart       # GoRouter configuration
    │   │   ├── app_routes.dart       # Route name constants
    │   │   └── app_transitions.dart  # Custom route transitions
    │   │
    │   ├── services/
    │   │   ├── app_bloc_observer.dart # Bloc lifecycle observer
    │   │   ├── app_initializer.dart   # App startup initialization
    │   │   ├── app_logger.dart        # Logging service
    │   │   ├── pref_keys.dart         # Shared prefs key constants
    │   │   └── shared_pref.dart       # Shared preferences wrapper
    │   │
    │   ├── style/
    │   │   ├── app_colors.dart       # Color palette
    │   │   └── app_theme.dart        # Theme configuration
    │   │
    │   ├── utils/
    │   │   └── context_extension.dart # BuildContext extensions
    │   │
    │   └── widgets/                  # Reusable UI components
    │       ├── animate_do.dart       # Animation helpers (fadeIn, slideIn)
    │       ├── background_container.dart
    │       ├── custom_back_button.dart
    │       ├── custom_button.dart
    │       ├── custom_icon_cackground.dart
    │       └── custom_text.dart
    │
    └── features/                     # 🧩 Feature modules
        │
        ├── home/                     # 📖 Main feature - Stories
        │   ├── data/
        │   │   ├── story_categories_list.dart  # Category seed data
        │   │   └── story_list.dart             # Story seed data
        │   │
        │   ├── helpers/
        │   │   └── function.dart     # Utility functions
        │   │
        │   ├── models/
        │   │   ├── story_category_model.dart
        │   │   └── story_model.dart
        │   │
        │   ├── views/
        │   │   ├── home_view.dart             # Main home screen
        │   │   ├── stories_list_view.dart      # Stories by category list
        │   │   └── story_reader_screen.dart    # Story reader with PDF + audio
        │   │
        │   └── widgets/
        │       ├── common/
        │       │   └── custom_card_background.dart  # Glassmorphism card
        │       │
        │       ├── home_view/
        │       │   ├── home_header_section.dart
        │       │   ├── home_story_card.dart
        │       │   ├── social_button.dart
        │       │   ├── social_media_row.dart
        │       │   └── stories_card_widget.dart
        │       │
        │       ├── stories_list/
        │       │   ├── stories_list_header.dart
        │       │   ├── stories_list_section.dart
        │       │   └── story_list_card.dart
        │       │
        │       └── story_reader/
        │           ├── cubit/
        │           │   └── audio_cubit.dart    # Audio playback state
        │           ├── audio_controls.dart      # Audio player UI
        │           ├── pdf_book_flip_local.dart # PDF viewer with page flip
        │           └── story_reader_header.dart
        │
        └── onboarding/               # 👋 Onboarding screens
            ├── data/
            │   └── onboarding_pages.dart     # Onboarding page content
            ├── model/
            │   └── onboarding_model.dart
            ├── views/
            │   └── onboarding_view.dart
            └── widgets/
                ├── onboarding_bottom_navigation.dart
                ├── onboarding_page_view.dart
                └── onboarding_widget.dart
```

---

## 📋 Architecture Overview

| Layer | Directory | Responsibility |
|-------|-----------|----------------|
| **Core** | `lib/core/` | Shared utilities, theme, routing, services |
| **Home** | `lib/features/home/` | Story browsing, reading, audio playback |
| **Onboarding** | `lib/features/onboarding/` | First-launch onboarding flow |

## 🎯 Key Design Decisions

- **State Management**: Flutter Bloc (`flutter_bloc`)
- **Navigation**: GoRouter with named routes
- **Audio**: `audioplayers` package via `AudioCubit`
- **PDF Viewing**: `pdfx` + `page_flip` for book-like experience
- **Responsive**: `flutter_screenutil` for adaptive layouts
- **Theming**: Custom color palette with gradient backgrounds

## 📦 Asset Organization

```
assets/
├── audio/    → Category-specific story audio files (MP3)
├── fonts/    → Tajawal font family (Bold, Medium, Regular, Light)
├── images/
│   ├── app/         → Application logos & branding
│   ├── covers/      → Story cover images (organized by category)
│   ├── labels/      → Category label/badge images
│   ├── onboarding/  → Onboarding walkthrough images
│   └── social/      → Social media icon SVGs
└── pdf/      → Story PDF files (organized by category)
```
