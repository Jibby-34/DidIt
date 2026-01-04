import 'package:flutter/foundation.dart';
import '../models/streak.dart';
import '../services/storage_service.dart';

class StreakProvider extends ChangeNotifier {
  List<Streak> _streaks = [];
  bool _isLoading = false;

  List<Streak> get streaks => _streaks;
  bool get isLoading => _isLoading;

  /// Load all streaks from storage
  Future<void> loadStreaks() async {
    _isLoading = true;
    notifyListeners();

    _streaks = StorageService.getStreaks();
    
    _isLoading = false;
    notifyListeners();
  }

  /// Add a new streak
  Future<void> addStreak(Streak streak) async {
    await StorageService.addStreak(streak);
    await loadStreaks();
  }

  /// Update an existing streak
  Future<void> updateStreak(Streak streak) async {
    await StorageService.updateStreak(streak);
    await loadStreaks();
  }

  /// Delete a streak
  Future<void> deleteStreak(String id) async {
    await StorageService.deleteStreak(id);
    await loadStreaks();
  }

  /// Complete a streak for today
  Future<void> completeStreak(String id) async {
    final streak = _streaks.firstWhere((s) => s.id == id);
    
    if (streak.canCompleteToday()) {
      streak.complete();
      await updateStreak(streak);
    }
  }

  /// Get streak by ID
  Streak? getStreakById(String id) {
    try {
      return _streaks.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Check if user can create more streaks
  Future<bool> canCreateStreak() async {
    return await StorageService.canCreateStreak(3); // Free tier limit
  }
}

