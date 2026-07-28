# 13 — CV Bullet Points

Professional resume bullets for the ICO Stories project. Each bullet follows the format: **Action + Technology + Impact**.

---

## Primary Bullets (Use on CV)

1. **Delivered** a full Flutter educational story app (ICO Stories) that won the **Khalifa Award for Educational Creativity** across the Arab world, serving Arabic-speaking children with 68 stories across 3 themed categories.

2. **Engineered** a PDF-to-page-flip rendering pipeline using `pdfx` and `page_flip`, converting each PDF page to in-memory `Image.memory` widgets and mirroring the 3D flip axis with `Matrix4.rotationY(π)` to support correct RTL book reading for Arabic content.

3. **Architected** a feature-based Flutter application using Cubit state management (`flutter_bloc`), GoRouter for declarative navigation, and a Repository pattern for clean separation between UI and data layers.

4. **Built** a full-featured audio player component using `audioplayers` with 4 reactive stream subscriptions, play/pause/seek/±10s skip controls, animated waveform display, and proper resource cleanup in `Cubit.close()` to prevent memory leaks.

5. **Implemented** responsive UI supporting phone and tablet layouts using `flutter_screenutil` and a centralised `context.isTablet` extension, ensuring consistent design across all screen sizes with zero layout duplication.

6. **Integrated** `AppBlocObserver` for global Cubit lifecycle monitoring across all state machines, providing full visibility into state transitions, events, and errors during development with debug-only logging guarded by `kDebugMode`.

7. **Applied** the `very_good_analysis` strict lint ruleset to enforce clean code standards including return type declarations, stream subscription cancellation, closed sinks, and no dynamic calls throughout the codebase.

8. **Managed** audio playback lifecycle across Android app lifecycle events by implementing `WidgetsBindingObserver`, ensuring audio pauses reliably when the app is backgrounded and all resources are disposed correctly on screen exit.

9. **Designed** a conditional feature architecture that initialises the `AudioCubit` and all associated stream subscriptions only for story categories that support audio (`char`, `tarbawia`), eliminating unnecessary resource allocation for the `sira` category.

10. **Configured** system-level immersive mode (`SystemUiMode.immersiveSticky`) during PDF story reading and correctly restored `SystemUiMode.edgeToEdge` on screen disposal, delivering a distraction-free full-screen reading experience for children.

---

## Supporting Bullets (Use as Context or in Portfolio)

- Structured the Flutter codebase with a `core/` layer for shared constants, widgets, routing, services, and theme, enabling zero coupling between features.

- Delivered 68 locally-bundled educational stories (PDFs + cover images + MP3 audio) with a consistent data model (`StoryModel`: id, title, pdfPath, coverImage, audioPath?) across all categories.

- Implemented an `AudioState` Cubit state class with an immutable `copyWith` pattern and a `progress` computed getter that drives the seek slider from real-time audio position streams.

- Built an animated onboarding flow with `page_flip`-style page transitions, dot indicator, skip-to-end navigation, and a first-launch flag persisted via `SharedPreferences`.

---

## One-Line Summary for LinkedIn / Portfolio

> Developed ICO Stories, an award-winning Flutter educational app for Arabic-speaking children featuring PDF book-flip reading with RTL animation, real-time audio playback management via Cubit state machines, and a fully offline content library of 68 illustrated stories.
