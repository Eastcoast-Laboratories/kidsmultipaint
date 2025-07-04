# Minimal Template Conversion Plan

## Notes
- User wants to convert the app into a minimal template.
- Only keep index.html and index template in the root and app folder.
- Remove all images and extra HTML files except index/index template.
- In the app folder, only index.html should remain; delete all others.
- Explored directory structure: index.html found in src, not public/partials.
- Both app/index.html and src/index.html are complex and need to be replaced with a minimal Hello World page.
- Both app/index.html and src/index.html have been replaced with minimal Hello World templates.
- app/images and src/images were deleted.
- app/partials was deleted (all extra HTML partials removed).
- favicon.ico was deleted from src.
- homepage directory in app only contains images (no extra HTML files found).
- app/homepage/images/screenshots contains additional images to be removed.
- app/homepage/images and all screenshots removed; empty app/homepage directory deleted.
- All unnecessary image and HTML files have been removed; minimal template is finalized.
- Android build now shows a black screen (needs investigation).
- Black screen likely caused by mismatch between expected dist/index.html (for Capacitor) and webpack output (dist/app/index.html or missing file).
- run.sh and webpack config use inconsistent ports (9091/9092); must standardize to 9092 everywhere.
- Webpack build currently fails due to missing favicon.ico reference and index.html output conflict; both must be fixed before verifying Android build.

## Task List
- [x] Remove all images from app/images and src/images.
- [x] Delete all HTML files in app/partials except index.html.
- [x] Delete favicon.ico and any other non-essential files in src.
- [x] Replace content with a Hello World start page.
- [x] Remove images from app/homepage/images/screenshots.
- [x] Standardize run.sh and webpack config to use port 9092 everywhere.
- [x] Investigate and fix black screen issue on Android build.
  - [x] Fix webpack output so dist/index.html is always present and correct for Capacitor.
- [ ] Fix webpack build errors: remove favicon.ico reference and resolve index.html output conflict.

## Current Goal
Investigate and verify Android build is working.