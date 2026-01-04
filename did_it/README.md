# ⚡ Did It - Lightning Streak Tracker

A lightweight, energetic mobile app for tracking daily streaks and building consistent habits.

## Features

- 🎯 **Simple Daily Check-ins** - One tap to mark completion, no confirmations
- ⚡ **Lightning-Themed UI** - Energetic animations and motivating design
- 🤖 **AI-Powered Setup** - Get personalized emoji, descriptions, and steps for each streak
- 📊 **Progress Tracking** - View current streaks, best streaks, and total completions
- 💰 **Flexible Monetization** - Free tier with ads, or premium subscription
- 🔔 **Smart Notifications** - Daily reminders with motivational messages

## Tech Stack

- **Flutter & Dart** - Cross-platform mobile development
- **Hive** - Local-first data persistence
- **Google AdMob** - Rewarded video ads
- **Google Gemini** - AI-powered streak suggestions (via Cloudflare Worker)
- **Provider** - State management

## Setup Instructions

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Configure AI Worker (Optional)

Update `lib/constants/app_constants.dart`:

```dart
static const String aiWorkerUrl = 'https://your-worker-url.workers.dev/generate';
```

The app will use fallback suggestions if no worker is configured.

### 3. Configure AdMob

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-YOUR_ANDROID_APP_ID~XXXXXXXXXX"/>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-YOUR_IOS_APP_ID~XXXXXXXXXX</string>
```

**Ad Unit IDs** (`lib/constants/app_constants.dart`):
```dart
static const String prodRewardedAdIdAndroid = 'ca-app-pub-XXXXX/XXXXX';
static const String prodRewardedAdIdIOS = 'ca-app-pub-XXXXX/XXXXX';
```

### 4. Configure In-App Purchases

Update your product IDs in:
- `lib/constants/app_constants.dart`
- App Store Connect (iOS)
- Google Play Console (Android)

### 5. Run the App

```bash
# Debug mode (uses test AdMob IDs)
flutter run

# Release mode
flutter run --release
```

## Project Structure

```
lib/
├── constants/          # App-wide constants
├── models/            # Data models (Streak)
├── providers/         # State management
├── screens/           # UI screens
│   ├── home_screen.dart
│   ├── create_streak_screen.dart
│   └── streak_detail_screen.dart
├── services/          # Business logic
│   ├── storage_service.dart
│   ├── ai_service.dart
│   ├── ads_service.dart
│   ├── notification_service.dart
│   └── subscription_service.dart
├── theme/             # App theming
├── widgets/           # Reusable widgets
└── main.dart          # App entry point
```

## Key Implementation Details

### Free vs Premium

- **Free Tier**: 3 streaks maximum, rewarded ads to unlock features
- **Premium**: Unlimited streaks, no ads, instant AI setup ($3/month)

### Daily Logic

Streaks are completed once per day. The app:
- Checks if today's date differs from last completion
- Breaks streaks if a day is missed
- Tracks best streak and total completions

### Lightning Animations

Fast, satisfying feedback on streak completion:
- Scale and fade animations
- Pulsing glow effects for incomplete streaks
- No confirmation dialogs for speed

### AdMob Integration

Platform-aware ad configuration:
- Debug mode: Test ad IDs
- Release mode: Production IDs (platform-specific)
- Rewarded ads only, no banners or interstitials

## Cloudflare Worker API

Expected request format:

```json
{
  "type": "streak_setup",
  "streakName": "Study Japanese",
  "tone": "motivating"
}
```

Expected response:

```json
{
  "emoji": "⚡",
  "description": "Build your Japanese skills one day at a time!",
  "steps": [
    "Practice hiragana for 10 minutes",
    "Learn 5 new vocabulary words",
    "Review yesterday's lesson"
  ]
}
```

## TODOs Before Launch

- [ ] Replace AdMob placeholder IDs with real IDs
- [ ] Set up Cloudflare Worker for AI (or rely on fallback)
- [ ] Configure in-app purchase product IDs
- [ ] Test on physical iOS and Android devices
- [ ] Set up app icons and splash screens
- [ ] Configure Firebase (optional, for analytics)
- [ ] Add settings screen with notification preferences
- [ ] Implement restore purchases button

## Design Philosophy

**Fast & Focused**
- No accounts or login required
- Local-first data storage
- One-tap interactions
- Minimal UI, maximum impact

**Motivating**
- Lightning ⚡ theme for energy
- Satisfying animations
- Encouraging language
- Progress visualization

**Indie-Friendly**
- No complex backend infrastructure
- Optional AI enhancement
- Straightforward monetization
- Easy to maintain

## License

This project is built as an example implementation. Modify and use as needed.

---

Built with ⚡ and Flutter
