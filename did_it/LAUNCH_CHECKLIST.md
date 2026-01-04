# ⚡ Did It - Launch Checklist

Use this checklist before submitting to the App Store and Google Play Store.

## Pre-Launch Configuration

### 1. AdMob Setup
- [ ] Created AdMob account
- [ ] Created Android app in AdMob
- [ ] Created iOS app in AdMob
- [ ] Created rewarded ad units for both platforms
- [ ] Updated Android App ID in `AndroidManifest.xml`
- [ ] Updated iOS App ID in `Info.plist`
- [ ] Updated production ad unit IDs in `app_constants.dart`
- [ ] Tested ads on real devices (not emulator)

### 2. In-App Purchases
- [ ] Created App Store Connect app (iOS)
- [ ] Created Google Play Console app (Android)
- [ ] Created subscription product on both platforms
- [ ] Product ID matches in code: `did_it_premium_monthly`
- [ ] Price set to $3.00/month on both platforms
- [ ] Tested with sandbox accounts
- [ ] Restore purchases works correctly

### 3. AI Integration (Optional)
- [ ] Created Google Gemini API key
- [ ] Deployed Cloudflare Worker
- [ ] Set GEMINI_API_KEY secret in worker
- [ ] Updated worker URL in `app_constants.dart`
- [ ] Tested AI streak generation
- [ ] Verified fallback works when AI unavailable

### 4. App Identity
- [ ] Updated bundle identifier (Android: `build.gradle.kts`)
- [ ] Updated bundle identifier (iOS: Xcode project)
- [ ] Created app icons (1024x1024 base)
- [ ] Generated launcher icons for all platforms
- [ ] Created splash screen
- [ ] Updated app name in both platforms
- [ ] Verified app displays correctly on home screen

### 5. Code Quality
- [ ] No linter errors: `flutter analyze`
- [ ] All tests pass (if any): `flutter test`
- [ ] No debug prints in production code
- [ ] Removed all TODO comments or addressed them
- [ ] Code is properly formatted: `flutter format .`

## Testing Checklist

### Core Functionality
- [ ] App launches successfully
- [ ] Can create a new streak
- [ ] AI generates appropriate emoji/description/steps
- [ ] Can complete a streak (lightning animation plays)
- [ ] Streak counter increments correctly
- [ ] Can only complete once per day
- [ ] Streak breaks if day is missed
- [ ] Best streak tracks correctly
- [ ] Total completions count is accurate
- [ ] Can view streak details
- [ ] Can delete a streak
- [ ] Long-press on streak opens details

### Free Tier Limits
- [ ] Can create up to 3 streaks for free
- [ ] 4th streak shows limit message
- [ ] "Watch Ad" button appears
- [ ] Watching ad unlocks streak creation
- [ ] "Upgrade to Premium" button works

### Premium Features
- [ ] Premium purchase flow works
- [ ] Premium status persists after restart
- [ ] Premium users can create unlimited streaks
- [ ] Premium users see no ads
- [ ] Premium badge shows in settings
- [ ] Restore purchases works

### Ads
- [ ] Rewarded ads load successfully
- [ ] Ads show correctly
- [ ] Reward is granted after watching
- [ ] Next ad preloads after showing
- [ ] Handles ad load failures gracefully
- [ ] Uses test IDs in debug mode
- [ ] Uses production IDs in release mode

### UI/UX
- [ ] Lightning animations are smooth
- [ ] Glow effects work on incomplete streaks
- [ ] Dark theme looks good
- [ ] All text is readable
- [ ] No UI overflow errors
- [ ] Pull to refresh works
- [ ] Navigation flows smoothly
- [ ] Back button works correctly

### Edge Cases
- [ ] Works offline (except AI features)
- [ ] Handles network errors gracefully
- [ ] Handles AI service failures
- [ ] Works after device restart
- [ ] Works after app is killed and reopened
- [ ] Handles date/time changes correctly
- [ ] Works across different screen sizes
- [ ] Works on tablets

### Platform-Specific (Android)
- [ ] Back button behavior is correct
- [ ] Notifications work (if enabled)
- [ ] App icon looks good
- [ ] Splash screen displays
- [ ] No crashes on various Android versions
- [ ] Tested on multiple device sizes

### Platform-Specific (iOS)
- [ ] Swipe back gesture works
- [ ] Notifications work (if enabled)
- [ ] App icon looks good
- [ ] Splash screen displays
- [ ] No crashes on various iOS versions
- [ ] Tested on multiple device sizes
- [ ] Safe area insets respected

## Store Assets

### Screenshots
- [ ] iPhone 6.7" (1290 x 2796) - 3-10 screenshots
- [ ] iPhone 6.5" (1284 x 2778) - 3-10 screenshots
- [ ] iPhone 5.5" (1242 x 2208) - 3-10 screenshots
- [ ] Android Phone - 2-8 screenshots
- [ ] Android Tablet - 2-8 screenshots (optional)

### App Store (iOS)
- [ ] App name (30 chars max)
- [ ] Subtitle (30 chars max)
- [ ] Description (4000 chars max)
- [ ] Keywords (100 chars max)
- [ ] Support URL
- [ ] Privacy policy URL
- [ ] App category selected
- [ ] Age rating completed
- [ ] Screenshots uploaded
- [ ] App icon uploaded (1024x1024)
- [ ] App preview video (optional)

### Google Play (Android)
- [ ] App name (50 chars max)
- [ ] Short description (80 chars max)
- [ ] Full description (4000 chars max)
- [ ] Screenshots uploaded
- [ ] Feature graphic (1024 x 500)
- [ ] App icon (512 x 512)
- [ ] Privacy policy URL
- [ ] App category selected
- [ ] Content rating completed
- [ ] Target audience selected

## Legal & Privacy

- [ ] Privacy policy created and hosted
- [ ] Privacy policy URL added to stores
- [ ] Privacy policy mentions data collection:
  - [ ] Local data storage (Hive)
  - [ ] AdMob (if applicable)
  - [ ] In-app purchases
  - [ ] No user accounts/personal data
- [ ] Terms of service created (optional)
- [ ] COPPA compliance verified
- [ ] GDPR compliance verified (if targeting EU)

## Build & Release

### Android
- [ ] Generated signing key
- [ ] Created `key.properties` file
- [ ] Updated `build.gradle.kts` with signing config
- [ ] Built release bundle: `flutter build appbundle`
- [ ] Tested release build on device
- [ ] Version code incremented
- [ ] Version name updated

### iOS
- [ ] Created App Store Connect app
- [ ] Configured signing in Xcode
- [ ] Built archive in Xcode
- [ ] Uploaded to App Store Connect
- [ ] Build number incremented
- [ ] Version number updated

## Post-Submission

### Monitoring
- [ ] Set up crash reporting (Firebase Crashlytics)
- [ ] Set up analytics (Firebase Analytics)
- [ ] Monitor AdMob earnings
- [ ] Monitor subscription revenue
- [ ] Monitor app reviews
- [ ] Monitor crash reports

### Marketing (Optional)
- [ ] Created landing page
- [ ] Prepared social media posts
- [ ] Prepared launch announcement
- [ ] Reached out to app review sites
- [ ] Created demo video
- [ ] Prepared press kit

## Version 1.0.0 Release Notes

```
⚡ Did It - Version 1.0.0

Initial release! Track your daily habits with the most energetic streak tracker ever made.

Features:
• One-tap daily check-ins
• Lightning-fast animations
• AI-powered streak suggestions
• Beautiful dark theme
• Track up to 3 streaks for free
• Premium: Unlimited streaks, no ads

Build momentum. Keep the lightning going! ⚡
```

## Emergency Contacts

- **Developer**: [Your contact]
- **AdMob Support**: https://support.google.com/admob
- **App Store Support**: https://developer.apple.com/contact/
- **Play Store Support**: https://support.google.com/googleplay/android-developer

---

## Final Check

Before hitting "Submit for Review":

1. ✅ All checkboxes above are checked
2. ✅ Tested on multiple real devices
3. ✅ No critical bugs found
4. ✅ All store assets uploaded
5. ✅ Privacy policy is live
6. ✅ AdMob and IAP are configured
7. ✅ Version numbers are correct
8. ✅ You're ready to support users!

**Good luck with your launch! ⚡**

