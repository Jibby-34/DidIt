# Did It

A minimal, beautifully designed streak tracker for iOS and Android.

## 🎯 About

Did It is a calm, focused habit tracker that helps you build daily streaks without the noise. No ads, no subscriptions, no backend—just you and your daily habits.

### Design Philosophy

- **Fast & Minimal**: Every interaction is intentional and responsive
- **Calm Confidence**: Muted colors, clean typography, plenty of space
- **Daily Focus**: One tap per day, that's all it takes
- **Privacy First**: All data stays on your device

## ✨ Features

- ✅ **Create Daily Streaks**: Track any habit or goal you want to build
- ✅ **One Tap Completion**: Simple tap to mark your streak complete for the day
- ✅ **Beautiful Design**: Off-white background with near-black text and muted green accents
- ✅ **Smart Streak Logic**: Automatic streak counting with calendar-day accuracy
- ✅ **Local Storage**: All data stored securely on your device using Hive
- ✅ **Detail Views**: See your progress with clear stats and dates
- ✅ **No Clutter**: Clean interface with no unnecessary features

## 🎨 Design System

### Colors
- **Background**: Warm off-white (#FAF9F6)
- **Primary Text**: Near-black (#1A1A1A)
- **Success**: Muted green (#5C8D5A)
- **Dividers**: Light gray (#E5E5E5)

### Iconography
- Bold, simple checkmark as the core symbol
- Calm and confident, not celebratory
- Minimal use of icons elsewhere

## 🏗️ Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/
│   ├── streak.dart               # Streak data model
│   └── streak.g.dart             # Generated Hive adapter
├── services/
│   └── streak_service.dart       # Data persistence & business logic
├── theme/
│   └── app_theme.dart            # Design system & theme
└── screens/
    ├── home_screen.dart          # Main streak list
    ├── create_streak_screen.dart # Create new streaks
    └── streak_detail_screen.dart # Detailed streak view
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.10.3 or higher)
- iOS development setup (for iOS)
- Android development setup (for Android)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd did_it
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate Hive adapters (if needed):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

## 📱 How to Use

1. **Create a Streak**: Tap the "New Streak" button and give your habit a name
2. **Complete Daily**: Tap a streak card to mark it complete for the day
3. **View Details**: Tap the arrow icon to see detailed stats
4. **Delete**: Long-press a streak card or use the delete button in details

## 🔧 Technical Details

### Dependencies

- **hive**: Local NoSQL database
- **hive_flutter**: Flutter integration for Hive
- **uuid**: Unique ID generation
- **intl**: Date formatting

### Streak Logic

- Streaks can only be marked complete once per 24 hours (calendar day basis)
- If you miss a day, your streak resets to 1 on the next completion
- Tapping an already-completed streak does nothing (calm, no errors)
- All date comparisons use local device time

## 📦 Building for Release

### Android

```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## 🎯 Scope

This is a pure MVP focused on:
- ✅ Core streak tracking
- ✅ Beautiful, minimal UI
- ✅ Local data persistence
- ✅ Calendar-day logic

This app intentionally **does NOT include**:
- ❌ Ads or monetization
- ❌ User accounts or login
- ❌ Cloud sync or backend
- ❌ Social features
- ❌ Analytics or tracking
- ❌ Gamification or rewards

## 📄 License

This project is private and not licensed for public use.

---

**Built with Flutter** 🎯
*"I quietly show up every day."*
