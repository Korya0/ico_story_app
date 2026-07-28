# 06 — Technical Decisions

---

## Decision 1: Cubit over full BLoC

**Decision:** Use `Cubit` (a simplified version of BLoC without Events) for state management.

**Why Chosen:**
The app's state management needs are straightforward — load a list, emit a loaded state, handle an error. There is no complex event-chaining, no event debouncing, and no need to distinguish between multiple incoming events of the same type. Cubit eliminates the boilerplate of defining separate `Event` classes while retaining BLoC's structured state emission and testability.

**Alternatives Considered:**
- Full `Bloc` with events: more boilerplate for the same result; the app does not need event-level traceability
- `Provider`/`ChangeNotifier`: less structured, no built-in state sealing, weaker lint support
- `Riverpod`: more complex setup; strong for this scale but over-engineered for 2 cubits

**Tradeoffs:**
- Pro: Less code, cleaner Cubits, easier to read
- Pro: `AppBlocObserver` still provides full lifecycle visibility
- Con: Cannot replay specific events for debugging (not needed here)
- Con: Cannot use event transformers for debounce/throttle (not needed here)

---

## Decision 2: GoRouter for Navigation

**Decision:** Use `GoRouter` (URL-based declarative routing) instead of Flutter's `Navigator 2.0` API or `Navigator.push`.

**Why Chosen:**
GoRouter provides a clean, declarative route definition with named routes and type-safe `extra` parameters. It integrates natively with `MaterialApp.router`. The app needed named routes so that navigation calls are refactorable (`pushNamed(AppRoutes.storyReader, extra: {...})`).

**Alternatives Considered:**
- `Navigator.push`: imperative, not easily refactorable, no named routes
- `auto_route`: generates code for type-safe routes, but adds code generation complexity
- Raw `Navigator 2.0`: far too complex for 4 routes

**Tradeoffs:**
- Pro: Concise route definitions, easy initial-route logic
- Pro: Deep link support ready if needed in future
- Con: `extra` parameter passing is untyped (`Object?`) and requires casting at the destination — fragile if the caller forgets to include required keys
- Con: GoRouter `^16.2.1` is a very new version; API changes are common

---

## Decision 3: pdfx for PDF Rendering (Convert to Images)

**Decision:** Use `pdfx` to render PDF pages to `Uint8List` images, then display them as `Image.memory` widgets.

**Why Chosen:**
The `page_flip` widget requires a `List<Widget>`. There is no PDF viewer that natively integrates with a page-flip animation. `pdfx` allows programmatic rendering of each page to raw bytes, which can be wrapped in `Image.memory`. This pipeline makes any 3D flip widget compatible with PDFs.

**Alternatives Considered:**
- `flutter_pdfview`: renders PDFs natively in a scrollable view (declared in `pubspec.yaml` as `flutter_pdfview: 1.3.2`) — but this does not support 3D page flip; it provides a standard scroll/swipe viewer
- `syncfusion_flutter_pdfviewer`: enterprise-grade, licensed; native scroll-based viewer
- Not using page flip at all: would lose the key differentiating UX feature

**Tradeoffs:**
- Pro: Enables page-flip animation — a strong UX differentiator
- Pro: Pages are pre-rendered so flipping is instant after load
- Con: All pages are loaded into memory simultaneously (see Performance Analysis)
- Con: Initial load time increases linearly with page count
- Con: Some `char` category PDFs are very large (up to ~79MB for story 14) — significant memory pressure

---

## Decision 4: audioplayers over just_audio

**Decision:** Use `audioplayers: ^5.2.1` as the actual audio engine, despite `just_audio: ^0.9.36` also being declared in `pubspec.yaml`.

**Why Chosen:**
`audioplayers` provides the needed features: asset source playback, position/duration streams, play/pause/seek. It has a well-known, stable API. Only `audioplayers` is imported in `AudioCubit`; `just_audio` appears to be a leftover from an earlier evaluation.

**Alternatives Considered:**
- `just_audio`: more powerful (speed control, pitch, background audio, audio session management) — but not needed for the app's simple play/pause/seek use case
- `flutter_sound`: more complex API, more suited to recording

**Tradeoffs:**
- Pro: Simpler API sufficient for the use case
- Con: `just_audio` remains in `pubspec.yaml` unused, increasing APK size unnecessarily
- Recommendation: Remove `just_audio` from `pubspec.yaml`

---

## Decision 5: Static Local Data Instead of a Backend

**Decision:** All story content (68 stories, covers, PDFs, MP3s) is bundled as Flutter assets. No network calls, no database, no CMS.

**Why Chosen:**
The client (ICO) provides all story content at build time. There is no dynamic content feed. A backend would add infrastructure cost, complexity, and network dependency for users who may have limited connectivity. Bundling assets guarantees offline-first operation from day one.

**Alternatives Considered:**
- Firebase Storage for PDFs: would allow updating content without app releases, but requires network access and adds Firebase complexity
- REST API: unnecessary for static content
- SQLite/Hive for metadata: overhead not justified when 68 stories can be defined as Dart constants

**Tradeoffs:**
- Pro: Fully offline, zero network dependency, no server cost
- Pro: Instant data access — no loading spinners for story lists
- Con: App bundle size is very large (hundreds of MBs of PDFs and MP3s)
- Con: Adding new stories requires a new app release

---

## Decision 6: SharedPreferences for Onboarding Flag

**Decision:** Use `SharedPreferences` to persist whether the user has seen the onboarding.

**Why Chosen:**
This is the only piece of persistent state in the app. `SharedPreferences` is the simplest and most idiomatic Flutter solution for a single boolean flag. No schema, no migration, no overhead.

**Alternatives Considered:**
- `Hive`: overkill for a single boolean
- `flutter_secure_storage`: unnecessary — this is not sensitive data
- In-memory only: would show onboarding on every cold start

**Tradeoffs:**
- Pro: Minimal complexity, well-understood behaviour
- Con: `shared_preferences: any` is a wildly open version constraint — should be pinned (e.g., `^2.3.0`) to prevent unexpected breaking changes

---

## Decision 7: very_good_analysis Linting

**Decision:** Use `very_good_analysis` as the lint ruleset.

**Why Chosen:**
`very_good_analysis` is a strict, opinionated lint package from Very Good Ventures. It enforces best practices like `cancel_subscriptions`, `close_sinks`, `always_declare_return_types`, and `avoid_dynamic_calls`. These rules are valuable for a project with stream subscriptions and dynamic route extras.

**Alternatives Considered:**
- Flutter default `flutter_lints`: much less strict
- `pedantic`: deprecated
- Custom rules only: harder to maintain

**Tradeoffs:**
- Pro: Catches common issues at compile time (e.g., uncancelled subscriptions)
- Pro: Consistent code style enforced tooling-side
- Con: Some rules are relaxed in `analysis_options.yaml` (e.g., `public_member_api_docs: false`, `lines_longer_than_80_chars: false`) which shows the team adapted it to project needs

---

## Decision 8: Hardcoded Arabic Locale (ar_EG)

**Decision:** The app locale and text direction are hardcoded in `main.dart`.

```dart
locale: const Locale(AppConstant.ar, AppConstant.arCode), // ar_EG
builder: (context, child) => Directionality(
  textDirection: TextDirection.rtl,
  child: child!,
),
```

**Why Chosen:**
The app's entire user base is Arabic-speaking. All UI strings are in Arabic. Supporting multiple languages would require full localisation infrastructure (`.arb` files, `intl` package, locale detection) for no immediate user value.

**Alternatives Considered:**
- `flutter_localizations` with `.arb` files: proper i18n but unnecessary for a single-language app
- Device locale detection: would still only show Arabic content

**Tradeoffs:**
- Pro: Zero localisation overhead, simpler codebase
- Con: Not extensible — adding another language would require significant refactoring of all strings
- Con: App name and store listing must be Arabic-only

---

## Decision 9: Singleton Pattern for SharedPreferences

**Decision:** `SharedPref` is implemented as a singleton using a factory constructor.

```dart
class SharedPref {
  factory SharedPref() => preferences;
  SharedPref._internal();
  static final SharedPref preferences = SharedPref._internal();
}
```

**Why Chosen:**
`SharedPreferences.getInstance()` is async. The singleton pattern allows a one-time async initialisation in `AppInitializer.initialize()` and synchronous access everywhere else through `SharedPref()`.

**Tradeoffs:**
- Pro: Synchronous access after initialisation; no `await` at call sites
- Con: Hard to mock in tests without a DI abstraction around it
