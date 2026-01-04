# ⚡ Did It - Complete Setup Guide

This guide will walk you through setting up the Did It app from scratch.

## Prerequisites

- Flutter SDK (3.10.3 or higher)
- Android Studio / Xcode for mobile development
- Google AdMob account
- (Optional) Cloudflare account for AI features
- (Optional) Google Cloud account for Gemini API

## Step 1: Install Dependencies

```bash
cd did_it
flutter pub get
```

## Step 2: Configure AdMob

### Create AdMob Account & App

1. Go to [AdMob Console](https://apps.admob.com/)
2. Create a new app for Android and iOS
3. Create **Rewarded Ad Units** for both platforms
4. Note down your App IDs and Ad Unit IDs

### Update Android Configuration

**File: `android/app/src/main/AndroidManifest.xml`**

Replace the test App ID:
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-YOUR_ANDROID_APP_ID~XXXXXXXXXX"/>
```

### Update iOS Configuration

**File: `ios/Runner/Info.plist`**

Replace the test App ID:
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-YOUR_IOS_APP_ID~XXXXXXXXXX</string>
```

### Update Ad Unit IDs

**File: `lib/constants/app_constants.dart`**

```dart
// Production Ad Unit IDs
static const String prodRewardedAdIdAndroid = 'ca-app-pub-XXXXX/XXXXX';
static const String prodRewardedAdIdIOS = 'ca-app-pub-XXXXX/XXXXX';
```

## Step 3: Configure In-App Purchases (Optional)

### iOS Setup

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Create your app
3. Go to "In-App Purchases"
4. Create a new **Auto-Renewable Subscription**
   - Product ID: `did_it_premium_monthly`
   - Price: $3.00/month
5. Fill in all required metadata

### Android Setup

1. Go to [Google Play Console](https://play.google.com/console/)
2. Create your app
3. Go to "Monetization" → "Subscriptions"
4. Create a new subscription
   - Product ID: `did_it_premium_monthly`
   - Price: $3.00/month
5. Fill in all required metadata

### Update Product ID (if different)

**File: `lib/constants/app_constants.dart`**

```dart
static const String subscriptionProductId = 'your_product_id_here';
```

## Step 4: Set Up Cloudflare Worker for AI (Optional)

### Create Gemini API Key

1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create a new API key
3. Save it securely

### Deploy Cloudflare Worker

1. Install Wrangler CLI:
```bash
npm install -g wrangler
```

2. Login to Cloudflare:
```bash
wrangler login
```

3. Create a new worker:
```bash
wrangler init did-it-ai
```

4. Copy the contents of `cloudflare-worker-example.js` to your worker

5. Set the Gemini API key as a secret:
```bash
wrangler secret put GEMINI_API_KEY
# Paste your Gemini API key when prompted
```

6. Deploy the worker:
```bash
wrangler publish
```

7. Note the worker URL (e.g., `https://did-it-ai.your-subdomain.workers.dev`)

### Update App with Worker URL

**File: `lib/constants/app_constants.dart`**

```dart
static const String aiWorkerUrl = 'https://your-worker-url.workers.dev/generate';
```

**Note:** If you skip this step, the app will use fallback suggestions instead of AI-generated ones.

## Step 5: Configure App Icons & Splash Screen

### Using flutter_launcher_icons

1. Add to `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon.png"
  adaptive_icon_background: "#0A0E27"
  adaptive_icon_foreground: "assets/icon_foreground.png"
```

2. Create your icon images in an `assets/` folder

3. Generate icons:
```bash
flutter pub run flutter_launcher_icons
```

### Using flutter_native_splash

1. Add to `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_native_splash: ^2.3.10

flutter_native_splash:
  color: "#0A0E27"
  image: assets/splash_logo.png
  android: true
  ios: true
```

2. Generate splash screens:
```bash
flutter pub run flutter_native_splash:create
```

## Step 6: Update App Bundle Identifiers

### Android

**File: `android/app/build.gradle.kts`**

```kotlin
namespace = "com.yourcompany.didit"
applicationId = "com.yourcompany.didit"
```

### iOS

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select the Runner target
3. Update Bundle Identifier: `com.yourcompany.didit`

## Step 7: Test the App

### Debug Mode (Uses Test Ads)

```bash
flutter run
```

Test all features:
- ✅ Create a streak (AI or fallback)
- ✅ Complete a streak (see lightning animation)
- ✅ View streak details
- ✅ Watch a rewarded ad (test ad)
- ✅ Try to exceed free tier limit
- ✅ Navigate to premium screen
- ✅ Delete a streak

### Release Mode (Uses Production Ads)

```bash
# Android
flutter build apk --release
flutter install

# iOS
flutter build ios --release
# Then open Xcode and run on device
```

## Step 8: Prepare for Store Submission

### Android (Google Play)

1. Generate a signing key:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Create `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path-to-keystore>
```

3. Update `android/app/build.gradle.kts` with signing config

4. Build release bundle:
```bash
flutter build appbundle
```

### iOS (App Store)

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select "Any iOS Device" as target
3. Product → Archive
4. Distribute App → App Store Connect

### Required Store Assets

**Screenshots:**
- iPhone: 6.5" and 5.5" displays
- Android: Phone and Tablet

**App Description:**
```
⚡ Did It - Lightning Streak Tracker

Build consistent habits with the most energetic streak tracker ever made.

FEATURES:
• One-tap daily check-ins
• Lightning-fast animations
• AI-powered streak suggestions
• Beautiful dark theme
• Track unlimited streaks (Premium)
• No ads (Premium)

Perfect for tracking:
• Workouts
• Study sessions
• Reading
• Meditation
• Any daily habit!

Keep the lightning going. Don't break the chain! ⚡
```

**Keywords:**
```
habit tracker, streak tracker, daily habits, consistency, motivation, productivity, goals
```

## Step 9: Post-Launch

### Monitor Crashes

Set up Firebase Crashlytics (optional):

1. Add Firebase to your project
2. Add `firebase_crashlytics` dependency
3. Initialize in `main.dart`

### Analytics (Optional)

Add Firebase Analytics:

1. Add `firebase_analytics` dependency
2. Track key events:
   - Streak created
   - Streak completed
   - Ad watched
   - Premium purchased

### User Feedback

Monitor reviews and ratings:
- Google Play Console
- App Store Connect

## Troubleshooting

### AdMob Not Loading

- Verify App IDs are correct
- Check internet connection
- Wait a few hours after creating ad units
- Ensure test device is registered for testing

### In-App Purchase Not Working

- Verify product IDs match exactly
- Ensure app is signed correctly
- Test with sandbox accounts
- Check subscription status in console

### AI Not Working

- Verify Cloudflare Worker URL is correct
- Check Gemini API key is set
- View worker logs: `wrangler tail`
- App will use fallback if AI fails

### Build Errors

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

## Environment Variables

For different environments (dev/staging/prod), consider using:

```dart
// lib/config/environment.dart
class Environment {
  static const bool isDevelopment = bool.fromEnvironment('DEVELOPMENT');
  static const String aiWorkerUrl = String.fromEnvironment(
    'AI_WORKER_URL',
    defaultValue: 'https://default-worker.workers.dev/generate',
  );
}
```

Run with:
```bash
flutter run --dart-define=DEVELOPMENT=true --dart-define=AI_WORKER_URL=https://dev-worker.workers.dev/generate
```

## Support

For issues or questions:
1. Check the README.md
2. Review this setup guide
3. Check Flutter documentation
4. Review AdMob/IAP platform docs

---

Good luck with your launch! ⚡

