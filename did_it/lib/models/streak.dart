import 'package:hive/hive.dart';

part 'streak.g.dart';

@HiveType(typeId: 0)
class Streak extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  int currentStreak;

  @HiveField(4)
  DateTime? lastCompletedDate;

  @HiveField(5)
  DateTime createdAt;

  Streak({
    required this.id,
    required this.name,
    this.description,
    this.currentStreak = 0,
    this.lastCompletedDate,
    required this.createdAt,
  });

  // Check if streak was completed today
  bool get isCompletedToday {
    if (lastCompletedDate == null) return false;
    
    final now = DateTime.now();
    final lastCompleted = lastCompletedDate!;
    
    return now.year == lastCompleted.year &&
           now.month == lastCompleted.month &&
           now.day == lastCompleted.day;
  }

  // Check if streak should be reset (missed a day)
  bool get shouldReset {
    if (lastCompletedDate == null) return false;
    
    final now = DateTime.now();
    final lastCompleted = lastCompletedDate!;
    
    // Calculate the difference in calendar days
    final nowDate = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime(lastCompleted.year, lastCompleted.month, lastCompleted.day);
    final difference = nowDate.difference(lastDate).inDays;
    
    // If more than 1 day has passed, reset
    return difference > 1;
  }

  // Mark streak as complete for today
  void markComplete() {
    if (isCompletedToday) return;
    
    if (shouldReset) {
      currentStreak = 1;
    } else {
      currentStreak++;
    }
    
    lastCompletedDate = DateTime.now();
  }
}

