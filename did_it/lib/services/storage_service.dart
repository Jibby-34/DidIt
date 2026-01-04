import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/streak.dart';

class StorageService {
  static const String _streaksBoxName = 'streaks';
  static const String _premiumKey = 'is_premium';
  static const String _onboardingKey = 'completed_onboarding';

  static Box<Streak>? _streaksBox;

  /// Initialize Hive and open boxes
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      // ignore: no_leading_underscores_for_local_identifiers
      final _adapter = StreakAdapter();
      Hive.registerAdapter(_adapter);
    }
    
    _streaksBox = await Hive.openBox<Streak>(_streaksBoxName);
  }

  /// Get all streaks
  static List<Streak> getStreaks() {
    return _streaksBox?.values.toList() ?? [];
  }

  /// Add a new streak
  static Future<void> addStreak(Streak streak) async {
    await _streaksBox?.put(streak.id, streak);
  }

  /// Update an existing streak
  static Future<void> updateStreak(Streak streak) async {
    await _streaksBox?.put(streak.id, streak);
  }

  /// Delete a streak
  static Future<void> deleteStreak(String id) async {
    await _streaksBox?.delete(id);
  }

  /// Get a specific streak by ID
  static Streak? getStreak(String id) {
    return _streaksBox?.get(id);
  }

  /// Check if user is premium
  static Future<bool> isPremium() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_premiumKey) ?? false;
  }

  /// Set premium status
  static Future<void> setPremium(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, value);
  }

  /// Check if onboarding is completed
  static Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  /// Mark onboarding as completed
  static Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  /// Get count of active streaks
  static int getStreakCount() {
    return _streaksBox?.length ?? 0;
  }

  /// Check if user can create more streaks
  static Future<bool> canCreateStreak(int maxFreeStreaks) async {
    final isPremiumUser = await isPremium();
    if (isPremiumUser) return true;
    
    final count = getStreakCount();
    return count < maxFreeStreaks;
  }
}

