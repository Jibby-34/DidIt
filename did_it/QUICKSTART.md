# ⚡ Did It - Quick Start Guide

Get the app running in 5 minutes!

## Prerequisites

- Flutter SDK installed and configured
- Android Studio or Xcode set up
- A device or emulator ready

## Step 1: Install Dependencies

```bash
cd did_it
flutter pub get
```

## Step 2: Run the App

```bash
flutter run
```

That's it! The app will run with:
- ✅ Test AdMob IDs (safe for development)
- ✅ Fallback AI suggestions (no worker needed)
- ✅ Local storage ready
- ✅ All features functional

## What You'll See

1. **Home Screen**: Empty state with "Create Streak" button
2. **Create Streak**: Enter a name, get AI fallback suggestions
3. **Streak Card**: Tap to complete, see lightning animation
4. **Settings**: Access premium and notification settings

## Test the Core Flow

### Create Your First Streak

1. Tap the "New Streak" floating button
2. Enter "Workout" or any habit name
3. Tap "Create Streak"
4. Wait for AI fallback (instant)
5. See your streak on the home screen

### Complete a Streak

1. Tap the streak card
2. Watch the lightning animation ⚡
3. See the streak counter increment
4. Notice the "✓ Completed today" status

### Test Free Tier Limit

1. Create 3 streaks (free limit)
2. Try to create a 4th
3. See the "Watch Ad" option appear
4. (In debug mode, test ads will show)

### View Streak Details

1. Long-press a streak card
2. See detailed stats, description, steps
3. Try deleting a streak

## Configuration (Optional)

### Use Your Own AdMob IDs

Edit `lib/constants/app_constants.dart`:

```dart
static const String prodRewardedAdIdAndroid = 'ca-app-pub-YOUR_ID/XXXXX';
static const String prodRewardedAdIdIOS = 'ca-app-pub-YOUR_ID/XXXXX';
```

### Set Up AI Worker

1. Deploy the Cloudflare Worker (see `cloudflare-worker-example.js`)
2. Update the URL in `lib/constants/app_constants.dart`:

```dart
static const String aiWorkerUrl = 'https://your-worker.workers.dev/generate';
```

## Troubleshooting

### "Pub get failed"
```bash
flutter clean
flutter pub get
```

### "No devices found"
- Start an emulator, or
- Connect a physical device with USB debugging

### "Build failed"
- Check Flutter version: `flutter --version` (need 3.10.3+)
- Run: `flutter doctor` to diagnose issues

### "Ads not loading"
- Normal in debug mode with test IDs
- Wait a few seconds for ad to load
- Check internet connection

## Next Steps

Once you've tested the app:

1. **Read SETUP_GUIDE.md** for production configuration
2. **Read LAUNCH_CHECKLIST.md** before submitting to stores
3. **Read PROJECT_SUMMARY.md** for architecture details

## Hot Reload Tips

While developing:
- Press `r` to hot reload (keeps state)
- Press `R` to hot restart (resets state)
- Press `p` to toggle debug paint
- Press `q` to quit

## Common Development Tasks

### Change Theme Colors

Edit `lib/theme/app_theme.dart`:
```dart
static const Color electricYellow = Color(0xFFFFF200);
static const Color neonGreen = Color(0xFF39FF14);
```

### Modify Free Tier Limit

Edit `lib/constants/app_constants.dart`:
```dart
static const int maxFreeStreaks = 3; // Change to any number
```

### Customize Notification Messages

Edit `lib/constants/app_constants.dart`:
```dart
static const List<String> notificationMessages = [
  "⚡ Your custom message here",
  // Add more...
];
```

## Project Structure Quick Reference

```
lib/
├── screens/        # UI screens
├── widgets/        # Reusable widgets
├── services/       # Business logic
├── models/         # Data models
├── providers/      # State management
├── theme/          # Styling
└── constants/      # Configuration
```

## Useful Commands

```bash
# Run with verbose logging
flutter run -v

# Build release APK
flutter build apk --release

# Check for issues
flutter analyze

# Format code
flutter format .

# Clear cache
flutter clean
```

## Getting Help

1. Check the error message carefully
2. Run `flutter doctor` for system issues
3. Check the README.md for detailed info
4. Review the SETUP_GUIDE.md for configuration
5. Search Flutter documentation

## What's Next?

Now that you have the app running:

- [ ] Explore all screens and features
- [ ] Modify the theme to your liking
- [ ] Set up your AdMob account
- [ ] Deploy a Cloudflare Worker for AI
- [ ] Test on real devices
- [ ] Prepare for launch!

---

**Happy coding! ⚡**

Need more details? Check out:
- **README.md** - Project overview
- **SETUP_GUIDE.md** - Production setup
- **PROJECT_SUMMARY.md** - Technical details
- **LAUNCH_CHECKLIST.md** - Pre-launch tasks

