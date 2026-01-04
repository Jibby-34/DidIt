/// App-wide constants
class AppConstants {
  // AI Worker URL - Replace with your Cloudflare Worker URL
  static const String aiWorkerUrl = 'https://your-worker-url.workers.dev/generate';
  
  // Subscription
  static const double subscriptionPriceMonthly = 3.0;
  static const String subscriptionProductId = 'did_it_premium_monthly';
  
  // Free tier limits
  static const int maxFreeStreaks = 3;
  
  // AdMob IDs
  // Test IDs for debug mode
  static const String testRewardedAdIdAndroid = 'ca-app-pub-3940256099942544/5224354917';
  static const String testRewardedAdIdIOS = 'ca-app-pub-3940256099942544/1712485313';
  
  // Production placeholders - Replace with your actual AdMob IDs
  static const String prodRewardedAdIdAndroid = 'ca-app-pub-XXXXX/XXXXX'; // TODO: Replace
  static const String prodRewardedAdIdIOS = 'ca-app-pub-XXXXX/XXXXX'; // TODO: Replace
  
  // Notification messages
  static const List<String> notificationMessages = [
    "⚡ Don't let your streak die today",
    "Your streak is still charging...",
    "⚡ Time to keep the lightning going!",
    "Don't break the chain today!",
    "⚡ Your streak needs you!",
  ];
}

