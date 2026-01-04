import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../constants/app_constants.dart';

class AdsService {
  static RewardedAd? _rewardedAd;
  static bool _isRewardedAdReady = false;

  /// Initialize Mobile Ads SDK
  static Future<void> init() async {
    await MobileAds.instance.initialize();
  }

  /// Get the appropriate rewarded ad unit ID based on platform and debug mode
  static String get _rewardedAdUnitId {
    if (kDebugMode) {
      // Use test IDs in debug mode
      return Platform.isAndroid
          ? AppConstants.testRewardedAdIdAndroid
          : AppConstants.testRewardedAdIdIOS;
    } else {
      // Use production IDs in release mode
      return Platform.isAndroid
          ? AppConstants.prodRewardedAdIdAndroid
          : AppConstants.prodRewardedAdIdIOS;
    }
  }

  /// Load a rewarded ad
  static Future<void> loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdReady = true;
          
          // Set up callbacks
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              _isRewardedAdReady = false;
              // Preload next ad
              loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _rewardedAd = null;
              _isRewardedAdReady = false;
              // Preload next ad
              loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          // Rewarded ad failed to load
          _isRewardedAdReady = false;
        },
      ),
    );
  }

  /// Check if a rewarded ad is ready to show
  static bool isRewardedAdReady() {
    return _isRewardedAdReady && _rewardedAd != null;
  }

  /// Show a rewarded ad
  static Future<bool> showRewardedAd() async {
    if (!isRewardedAdReady()) {
      return false;
    }

    bool earnedReward = false;

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        earnedReward = true;
        // User earned reward
      },
    );

    return earnedReward;
  }

  /// Dispose of ads
  static void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isRewardedAdReady = false;
  }
}

