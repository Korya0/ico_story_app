# 05 — Engineering Challenges

---

## Challenge 1: RTL Book-Flip Animation for Arabic PDF Content

### Problem
Implementing a realistic page-flip animation for Arabic content that reads right-to-left. Standard page-flip widgets assume left-to-right page turning, which produces a reversed, unnatural experience for Arabic readers. Simply wrapping with `Directionality` is insufficient because the 3D rotation axis itself becomes mirrored.

### Technical Reason
The `page_flip` package renders pages with a left-to-right flip by default. Arabic books are read right-to-left, meaning the "next page" turn should visually go from left to right (from the reader's perspective), the opposite of an English book. Additionally, `Directionality` RTL wrapping affects layout but not the 3D matrix transformation axis.

### Solution
A double `Matrix4.rotationY(π)` technique was applied in `PdfBookFlipLocal`:

```dart
// Outer Transform flips the entire PageFlipWidget
Transform(
  alignment: Alignment.center,
  transform: Matrix4.rotationY(3.141592653589793), // π radians = 180°
  child: PageFlipWidget(
    children: pages.map((img) {
      // Inner Transform flips each individual page back to correct orientation
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(3.141592653589793),
        child: pageContent,
      );
    }).toList(),
  ),
)
```

The outer flip mirrors the entire widget so page turns go in the Arabic direction. The inner flip on each page corrects the individual page content so the images appear right-side up and unmirrored.

### Impact
Arabic content reads in the correct right-to-left direction. Page-turn gestures feel natural for the target audience. The solution requires no modifications to the `page_flip` package itself, making it maintainable.

---

## Challenge 2: PDF Rendering Pipeline for Page-Flip Integration

### Problem
The `page_flip` package expects a `List<Widget>` — it needs all pages as pre-built widgets. However, PDF files cannot be passed directly to a Flutter widget. A rendering pipeline had to be built to convert PDF pages into Flutter-displayable images.

### Technical Reason
Flutter has no built-in PDF renderer. The `pdfx` package can render individual PDF pages to raw image bytes (`Uint8List`), but rendering is asynchronous and must complete for all pages before the flip widget can be initialised. Additionally, the rendering happens synchronously page-by-page (sequential `await` loop) because `PdfDocument` page objects must be opened and closed one at a time.

### Solution
A sequential async loading pipeline in `_loadPages()`:

```dart
Future<void> _loadPages() async {
  final doc = await PdfDocument.openAsset(widget.pdfPath);
  for (var i = 1; i <= doc.pagesCount; i++) {
    final page = await doc.getPage(i);
    final pageImage = await page.render(
      width: page.width * 0.7,
      height: page.height * 2,
    );
    if (pageImage != null) {
      pages.add(Image.memory(pageImage.bytes));
    }
    await page.close();  // Important: release page resource
  }
  setState(() { _isLoading = false; });
  widget.onPdfLoaded?.call();
}
```

A loading indicator covers the screen while pages are rendering. A `onPdfLoaded` callback notifies the parent screen (`StoryReaderView`) to show the header UI only after the PDF is ready.

### Impact
Seamless user experience — the loading indicator prevents a blank or broken state. The callback mechanism cleanly decouples rendering completion from UI state management. Memory usage is the known tradeoff (see Performance Analysis).

---

## Challenge 3: Audio Player Lifecycle Management

### Problem
Managing an `AudioPlayer` with multiple async streams in a Flutter Cubit while ensuring:
1. No stream subscription leaks when the screen is disposed
2. Audio pauses when the app goes to the background
3. UI correctly reflects all state transitions (loading → playing → paused → completed)
4. Slider position updates every tick without causing rebuild storms

### Technical Reason
`audioplayers` exposes 4 separate streams (duration, position, playerState, completion). Each must be subscribed and cancelled. The position stream emits very frequently (several times per second), which risks unnecessary rebuilds if state is emitted naively. App lifecycle must be observed separately via `WidgetsBindingObserver` on the parent widget, requiring coordination between the view and the cubit.

### Solution
`AudioCubit` manages 4 `StreamSubscription` objects as private fields:

```dart
StreamSubscription<Duration>? _durationSubscription;
StreamSubscription<Duration>? _positionSubscription;
StreamSubscription<PlayerState>? _stateSubscription;
StreamSubscription<void>? _completeSubscription;
```

The `close()` override cancels all subscriptions and disposes the player:

```dart
@override
Future<void> close() async {
  await _durationSubscription?.cancel();
  await _positionSubscription?.cancel();
  await _stateSubscription?.cancel();
  await _completeSubscription?.cancel();
  await _audioPlayer.dispose();
  await super.close();
}
```

`StoryReaderView` implements `WidgetsBindingObserver` and calls `_audioCubit?.handleAppLifecyclePause()` on background transitions. The slider uses a local `_isSliderDragging` flag to decouple the drag value from the Cubit's position stream during scrubbing.

### Impact
No resource leaks. Audio reliably pauses when the app is backgrounded. The slider responds smoothly during scrubbing without conflicting with real-time position updates from the stream.

---

## Challenge 4: Responsive Layout Across Phone and Tablet

### Problem
The app must work correctly on phones (common in target markets) and tablets (used in educational settings). Widget sizes, font sizes, paddings, and column counts must all adapt without duplicating entire widget trees.

### Technical Reason
Flutter's default responsive tools require repetitive `MediaQuery` calls, which can be cumbersome. The design baseline is `375 × 812` (a typical iPhone). Tablet breakpoint must be consistently checked across all layers without scattering `MediaQuery.of(context).size.width >= 600` calls everywhere.

### Solution
A `BuildContext` extension wrapping `flutter_screenutil`:

```dart
// lib/core/utils/context_extension.dart
extension ContextExtension on BuildContext {
  bool get isTablet => ScreenUtil().screenWidth >= 600;
}
```

All widgets use `context.isTablet` for branching. `flutter_screenutil` is initialised with `designSize: Size(375, 812)`. `CustomText` automatically scales font sizes for tablet via `tabletFontSize ?? fontSize * 1.6`.

### Impact
Consistent tablet/phone layouts throughout the app with a single, centrally defined breakpoint. Font scaling is automatic. Code reads cleanly: `isTablet ? 24 : 16` instead of verbose `MediaQuery` calls.

---

## Challenge 5: Conditional Audio Feature Based on Story Category

### Problem
The `sira` (Prophet's Biography) category has no audio narration, while `char` and `tarbawia` do. The story reader screen must conditionally initialise the audio subsystem only when needed, and hide all audio UI for `sira` stories without complicating the widget tree.

### Technical Reason
`AudioCubit` is expensive to create (initialises `AudioPlayer`, sets up 4 stream subscriptions, loads an audio file). Instantiating it unconditionally wastes resources for `sira` stories. Additionally, `BlocProvider<AudioCubit>.value` must be provided to `AudioControls` only when a cubit exists.

### Solution
`StoryReaderView` uses a computed bool `_isSurah`:

```dart
bool get _isSurah => widget.categoryId == AppKeys.sira;
```

`AudioCubit` is only created when `!_isSurah`:

```dart
void _initializeCubit() {
  if (!_isSurah) {
    _audioCubit = AudioCubit(audioAssetPath: widget.story.audioPath ?? '');
    _audioCubit!.initialize();
  }
}
```

The audio toggle button is only rendered when `storyType != null`. In the build method, `BlocProvider.value` is only wrapped when `_audioCubit != null`:

```dart
final audioContent = _audioCubit != null
    ? BlocProvider<AudioCubit>.value(value: _audioCubit!, child: _buildContent())
    : _buildContent();
```

### Impact
Zero resource waste for `sira` stories. No null pointer risks from accessing a non-existent cubit. Clean conditional UI rendering without deeply nested ternaries.

---

## Challenge 6: System UI Immersive Mode During PDF Reading

### Problem
During PDF reading, system UI bars (status bar, navigation bar) reduce the available reading area. Children benefit from a full-screen, distraction-free reading environment.

### Technical Reason
`SystemChrome.setEnabledSystemUIMode` must be set on entry and restored on exit. Failure to restore it leaves the app in immersive mode on other screens.

### Solution
`PdfBookFlipLocal` sets immersive mode in `initState` and restores edge-to-edge mode in `dispose`:

```dart
@override
void initState() {
  super.initState();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  _loadPages();
}

@override
void dispose() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  super.dispose();
}
```

### Impact
Full-screen reading experience during story viewing. System UI is correctly restored when the user navigates away from the story reader.
