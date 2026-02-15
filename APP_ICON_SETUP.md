# NERO VA App Icon Setup Guide

## Option 1: Using flutter_launcher_icons (Recommended)

This is the easiest way to automatically generate app icons for all platforms.

### Step 1: Add dependency to pubspec.yaml
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1
```

### Step 2: Configure flutter_launcher_icons in pubspec.yaml
Add this section at the end of pubspec.yaml:
```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/logos/app_icon.png"
```

### Step 3: Prepare your icon
1. Export the NERO VA logo as a 1024x1024 PNG image
2. Place it in: `assets/logos/app_icon.png`

### Step 4: Generate icons
Run in terminal:
```bash
flutter pub get
flutter pub run flutter_launcher_icons:main
```

This will automatically:
- Create Android icon files in mipmap-* folders
- Update iOS AppIcon.appiconset
- Update Android manifest (if needed)

---

## Option 2: Manual Icon Generation (Alternative)

### For Android:
1. Create the logo as PNG files in these sizes:
   - 192x192 → `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png`
   - 144x144 → `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png`
   - 96x96 → `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png`
   - 72x72 → `android/app/src/main/res/mipmap-hdpi/ic_launcher.png`
   - 48x48 → `android/app/src/main/res/mipmap-mdpi/ic_launcher.png`

2. Or use Adaptive Icons for Android 8.0+:
   - Create `ic_launcher_foreground.png` (your logo on transparent background)
   - Create `ic_launcher_background.xml` (solid color background)
   - Update `android/app/src/main/AndroidManifest.xml`

### For iOS:
2. Open `ios/Runner.xcworkspace` in Xcode
3. Go to Runner → Assets.xcassets → AppIcon
4. Drag and drop your icon files into the appropriate slots (1024x1024 is primary)

---

## Option 3: Export Logo Widget as PNG (For creating the base image)

Use this approach to export the Flutter logo widget as a PNG:

1. Install: `flutter pub add screenshot`
2. Create and run a test script to capture the logo
3. Export as high-res image
4. Then use Option 1 or 2 above

---

## Quick Summary:
✅ We've created the logo design as a Flutter widget in `lib/widgets/nero_va_logo.dart`
✅ To make it the actual app icon, use **flutter_launcher_icons** (easiest)
✅ Or manually place PNG files in Android/iOS directories

The logo consists of 4 colorful rounded pills (blue, orange, yellow, mint) stacked vertically.
