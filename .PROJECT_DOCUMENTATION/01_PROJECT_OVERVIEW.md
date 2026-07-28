# 01 — Project Overview

## Project Name
**ICO Stories App** (`ico_story_app`)

---

## Project Purpose

ICO Stories is a mobile application that delivers an educational digital library of Arabic-language children's stories. It combines PDF-based story reading with a book-page-flip animation effect and optional audio narration, providing an immersive reading experience specifically designed for young Arabic-speaking children.

The app was built as a client project and received the **Khalifa Award for Educational Creativity** across the Arab world, as stated in the onboarding screen (`AppStrings.onboardingAchievementDesc`).

---

## Business Problem

Parents and educators in Arabic-speaking communities lack accessible, high-quality, child-friendly digital platforms for Islamic and educational storytelling. Traditional PDF readers are not child-appropriate, have no audio support, and do not feel engaging to young users. This app solves that by wrapping curriculum-aligned stories in an attractive, child-focused interface with animated page-flip reading and synchronized audio narration.

---

## Target Users

- **Primary:** Arabic-speaking children aged approximately 4–12 years
- **Secondary:** Parents and teachers who guide children through the stories
- **Locale:** Hardcoded to Arabic Egypt (`ar_EG`) with full RTL layout

---

## Main Features

| Feature | Description |
|---|---|
| Onboarding | 4-page introduction to the app with skip/next navigation. Shown only once, persisted via SharedPreferences. |
| Story Category Selection | Home screen presents 3 story categories as visual cards with cover images. |
| Stories List | Grid view of all stories in a selected category with cover images, using MasonryGridView. |
| PDF Story Reader | Opens a story PDF using `pdfx`, renders pages as images in memory, then displays them with a book-flip animation via `page_flip`. |
| Audio Narration | For `char` and `tarbawia` categories, users can toggle an audio player that plays an MP3 companion track with play/pause, seek slider, and ±10s skip controls. |
| Social Media Links | Home screen includes direct links to ICO's Twitter/X, Instagram, and Facebook pages using `url_launcher`. |

---

## Story Content

| Category | Arabic Name | Stories | Audio |
|---|---|---|---|
| `char` | قصص الحروف (Letter Stories) | 28 stories | ✅ Yes |
| `tarbawia` | كنوز القيم (Values Stories) | 20 stories | ✅ Yes |
| `sira` | قصص السيرة النبوية (Prophet's Biography) | 20 stories | ❌ No |

**Total: 68 stories**

---

## Supported Platforms

| Platform | Status |
|---|---|
| Android | Primary target platform. Fully configured with icons, manifest, and permissions. |
| Web | Flutter web scaffold exists (`web/` folder, `index.html`, `manifest.json`) but not actively developed. |
| iOS | Not configured (no `ios/` folder present). |

---

## Project Complexity

**Medium complexity.** Key complexity drivers:

- PDF rendering pipeline: all pages of each PDF are decoded to in-memory images before display
- Book-flip animation with RTL mirroring (requires `Matrix4.rotationY` double-flip trick)
- Audio lifecycle management with 4 stream subscriptions and app lifecycle awareness
- State management with two separate Cubits coordinated within a single screen
- 68 statically defined stories with cover images (mix of `.png` and `.webp`), PDFs, and MP3s all bundled as assets
- Responsive design handling phone vs. tablet layouts consistently across all screens

---

## Overall Project Summary

ICO Stories is a clean, well-structured Flutter application targeting Arabic-speaking children. All content is bundled locally — there is no backend, no network calls, and no user accounts. The app architecture follows a feature-based structure with a data layer but without a full clean architecture domain layer. State is managed via Cubit (flutter_bloc). The reading experience is the technical centrepiece: PDF pages are rendered to `Image.memory` widgets and animated through a page-flip widget, with an accompanying audio player for two of the three story categories.

The app is a fully delivered client product (not a personal side project), has won an educational award, and is production-ready for Android distribution.
