# 14 — Portfolio Description

---

## Short Description

ICO Stories is an award-winning Flutter mobile application that delivers an interactive digital library of Arabic educational stories for children. It features 3D book-flip PDF reading, real-time audio narration, and a fully offline content library of 68 illustrated stories across three themed collections.

---

## Detailed Description

### The Problem

Arabic-speaking families lacked a purpose-built digital reading experience for children's educational stories. Generic PDF viewers feel clinical and uninspiring for young users. Children need an engaging, tactile experience that mirrors the joy of flipping through a physical book, ideally accompanied by audio narration to support pre-readers and auditory learners. The app needed to work fully offline — a critical requirement given connectivity challenges in the target market.

### The Solution

ICO Stories solves this by combining three core experiences into a single, beautifully designed Flutter application:

1. **Book-flip reading** — PDFs are rendered page-by-page into memory using `pdfx`, then animated with a realistic 3D page-flip gesture via the `page_flip` widget. A custom RTL-mirroring technique using `Matrix4.rotationY(π)` ensures the flip direction is correct for Arabic content, creating a natural right-to-left reading experience.

2. **Audio narration** — For 48 of the 68 stories (`char` and `tarbawia` categories), a companion MP3 audio track narrates the story. The audio player was built from scratch with `audioplayers`, featuring play/pause, seek, ±10 second skip, animated waveform display, and proper resource management across screen transitions and app lifecycle changes.

3. **Offline-first content** — All 68 stories, their PDF files, MP3 audio tracks, and cover images are bundled directly in the app. No internet connection is ever required to read or listen to a story.

### Features

- **3 story categories:** قصص الحروف (Letter Stories, 28 stories), كنوز القيم (Values Stories, 20 stories), قصص السيرة النبوية (Prophet's Biography, 20 stories)
- **3D book-flip page animation** with RTL Arabic direction support
- **In-app audio player** with progress bar, time display, and haptic feedback
- **Animated onboarding** — 4-page introduction shown once, then skipped forever
- **Social media integration** — links to ICO's Twitter/X, Instagram, and Facebook
- **Responsive layout** — adapts to phone and tablet screen sizes
- **Fully offline** — zero network requests after install

### Technologies

| Layer | Technology |
|---|---|
| Framework | Flutter 3 / Dart 3 |
| State Management | Cubit (flutter_bloc) |
| Navigation | GoRouter |
| PDF Rendering | pdfx |
| Page Animation | page_flip |
| Audio | audioplayers |
| Animations | animate_do |
| Responsive | flutter_screenutil |
| Storage | shared_preferences |
| Social Links | url_launcher |
| Code Quality | very_good_analysis |

### Technical Highlights

**RTL PDF Book-Flip:** The biggest technical challenge was making the page-flip widget work in the correct direction for Arabic text. Standard flip widgets assume left-to-right. The solution applies a double `Matrix4.rotationY(π)` transform — one on the outer container to reverse the flip direction, and one on each page to correct the content orientation. This required careful understanding of 3D matrix transformations in Flutter.

**Audio Lifecycle Management:** `AudioCubit` manages an `AudioPlayer` with 4 concurrent `StreamSubscription` objects that track duration, position, playback state, and completion. All subscriptions are correctly cancelled in `close()`, and the parent `StoryReaderView` implements `WidgetsBindingObserver` to pause audio when the app is backgrounded. This prevents resource leaks and background audio surprises.

**Conditional Feature Architecture:** The `sira` category (Prophet's Biography) has no audio narration. Rather than polluting the UI with hidden/disabled audio controls, `AudioCubit` is simply not instantiated for `sira` stories, and the entire audio toggle button is conditionally omitted from the header. This keeps the reader screen clean and avoids allocating unnecessary resources.

**Award-winning product:** The app was recognised with the **Khalifa Award for Educational Creativity** across the Arab world, validating the quality and educational value of the product.

### Platforms

- Android (primary, fully deployed)
- Web (scaffold present, not actively deployed)

### Role

Solo developer — architecture, implementation, UI, and delivery.

---

## Screenshots

Three screenshots are available in the `screenshots/` directory:
- `ico_bannar.jpg` — App banner
- `ico_1.png` — Home screen
- `ico_2.png` — Story reader
- `ico_3.png` — Category/stories list
