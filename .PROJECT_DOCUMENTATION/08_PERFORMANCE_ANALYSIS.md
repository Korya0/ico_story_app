# 08 — Performance Analysis

---

## 1. PDF Rendering: Memory Usage Risk

### What Happens
`PdfBookFlipLocal._loadPages()` loads ALL pages of a PDF into memory before display:

```dart
for (var i = 1; i <= doc.pagesCount; i++) {
  final page = await doc.getPage(i);
  final pageImage = await page.render(
    width: page.width * 0.7,
    height: page.height * 2,
  );
  if (pageImage != null) {
    pages.add(Image.memory(pageImage.bytes));  // all in memory
  }
  await page.close();
}
```

### Scale of the Problem
The `char` category contains some very large PDF files:

| File | Size |
|---|---|
| `14-Alsos_Wa_Algorab.pdf` | **~79 MB** |
| `3-Alfarashat_AlHazeena.pdf` | ~41 MB |
| `10-Altoyour_Tatasaba9.pdf` | ~32 MB |
| Several others | 20–30 MB each |

When rendered, each PDF page becomes a `Uint8List` in memory at the specified render size. With `height: page.height * 2`, the rendered resolution is double the original. For a 20-page story, this could mean 20 large in-memory images simultaneously.

### Risk
On low-end Android devices (which are common in the target market), keeping all rendered pages in memory can trigger:
- OOM (Out of Memory) crashes
- Slow rendering causing jank
- Increased GC pressure

### Current Mitigation
- Pages are closed immediately after rendering (`await page.close()`) — this frees the `pdfx` page object but the rendered `Uint8List` bytes remain in `pages` list
- Render width is reduced to `page.width * 0.7` (30% reduction) — this helps but applies only to width

### Recommendation
Implement lazy page loading — only render pages near the current visible page (e.g., current ± 2). Dispose rendered images for pages far from the current position.

---

## 2. Widget Rebuilds

### HomeCubit BlocBuilder Scope
`BlocBuilder<HomeCubit, HomeState>` in `StoriesCardsWidget` rebuilds whenever `HomeCubit` emits a new state. Since `HomeCubit` only emits once per operation (Loading → Loaded), this is not a concern for excessive rebuilds.

### AudioCubit BlocBuilder Frequency
`BlocBuilder<AudioCubit, AudioState>` in `AudioControls` rebuilds on every state emission. The `onPositionChanged` stream emits multiple times per second (typically every 200ms with `audioplayers`). This means `AudioControls` rebuilds several times per second during playback.

**Current approach:** The entire `AudioControls` widget tree is wrapped in a single `BlocBuilder`. This rebuilds all sub-widgets including `_TitleSection`, `_TimeDisplay`, `_ProgressSlider`, and `_ControlButtons` on every position update.

**Optimisation opportunity:** Split the `BlocBuilder` into separate builders per sub-widget, or use `BlocSelector` to rebuild only widgets that depend on `currentPosition`:

```dart
// More efficient:
BlocSelector<AudioCubit, AudioState, Duration>(
  selector: (state) => state.currentPosition,
  builder: (context, position) => _TimeDisplay(...),
)
```

---

## 3. Image Asset Loading

### Cover Images — Mixed Format Performance
Story cover images use both `.png` and `.webp` formats. `.webp` files are significantly smaller (24–44 KB) vs `.png` covers (many in the 5–13 MB range for `char` and `sira` categories).

| Category | Cover Format | Sizes |
|---|---|---|
| `tarbawia` | `.webp` | 19–42 KB — excellent |
| `char` | Mix of `.png` and `.webp` | `.png`: 5–13 MB (very large), `.webp`: 25–54 KB |
| `sira` | `.png` | 1.5–7.8 MB — large |

**Issue:** Large `.png` cover images (some up to 13 MB for `char` category) are loaded into `Image.asset()` widgets in the `MasonryGridView`. Flutter caches decoded images in the image cache (`PaintingBinding.instance.imageCache`). Displaying 28 cover images for the `char` category simultaneously could consume significant memory.

**Recommendation:**
- Convert all remaining `.png` covers to `.webp` — this would reduce the covers from MB to tens of KB each
- Use `cacheWidth`/`cacheHeight` parameters on `Image.asset()` to load at display resolution, not original resolution

### Skeletonizer Package
`skeletonizer: ^2.1.3` is in `pubspec.yaml` but no skeleton loading states are implemented anywhere in the reviewed code. If implemented, skeleton screens would improve perceived performance during the brief `HomeLoading` state.

---

## 4. Staggered Grid View

### flutter_staggered_grid_view — MasonryGridView

```dart
MasonryGridView.count(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  crossAxisCount: 2,
  // ...
)
```

`shrinkWrap: true` forces the grid to calculate the full height of all items upfront. Combined with `NeverScrollableScrollPhysics()` (nested inside `CustomScrollView` with `SliverToBoxAdapter`), all 28 items are laid out simultaneously on the `char` category grid.

For 28 items this is manageable, but it is not lazily loaded — all story cards are in the widget tree at once.

**Recommendation:** Use `SliverMasonryGrid` directly inside the `CustomScrollView` to enable native lazy loading.

---

## 5. Orientation Lock

**File:** `lib/core/services/app_initializer.dart`

```dart
await SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
  DeviceOrientation.portraitDown,
]);
```

The app is locked to portrait. This is a performance-positive decision:
- No layout recalculations on rotation
- No need to handle different aspect ratios in the PDF viewer
- Consistent on all devices

---

## 6. Animation Performance

### animate_do animations
`FadeInUp`, `FadeInLeft`, etc. are CSS-style animations using `AnimationController`. They run for 500–600ms on widget appearance. These are short-lived and do not persist.

### Audio Wave Animation
`_waveController` in `AudioControls` runs continuously while audio is playing (`repeat(reverse: true)`, 1500ms period). This drives `AnimatedWidget` (`_TitleSection`). The animation updates 60fps during playback.

**Observation:** The wave animation is kept in `AudioControls._AudioControlsState`, not in the Cubit. This is correct — it is purely visual and should not be in business logic.

### Play Button Scale Animation
`_playButtonController` (`AnimationController`, 200ms, `Tween<double>(1, 0.95)`) triggers on button tap press/release. This is very short-lived and performant.

---

## 7. App Startup Performance

`AppInitializer.initialize()` runs 3 operations sequentially:

```dart
WidgetsFlutterBinding.ensureInitialized();   // synchronous
Bloc.observer = AppBlocObserver();            // synchronous
await SystemChrome.setPreferredOrientations([...]);
await SharedPref().instantiatePreferences(); // async disk read
```

Only 2 async operations with no network calls. App startup should be very fast.

**Issue:** `DevicePreview` wraps the entire app in `main.dart`, which adds a significant development-mode overhead and should be removed before production builds.

---

## 8. No Caching, No Pagination

Since all data is local and static:
- No network caching is needed (there are no network calls)
- No pagination is needed (lists have at most 28 items)
- No image prefetching/precaching is implemented for cover images

---

## Performance Summary

| Area | Status | Severity |
|---|---|---|
| PDF in-memory rendering of all pages | Risk on large files | High |
| Large .png cover images (up to 13 MB) | Memory pressure in grid view | Medium |
| AudioCubit BlocBuilder full-tree rebuild on position updates | Minor inefficiency | Low |
| shrinkWrap MasonryGridView | All items laid out at once | Low |
| App startup | Fast (no network, minimal async) | Good |
| Orientation lock | Performance positive | Good |
| Animation efficiency | Short-lived, correct placement | Good |
