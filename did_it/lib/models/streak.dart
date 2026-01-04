import 'package:hive/hive.dart';

part 'streak.g.dart';

@HiveType(typeId: 0)
class Streak {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String emoji;

  @HiveField(3)
  String description;

  @HiveField(4)
  List<String> steps;

  @HiveField(5)
  int currentStreak;

  @HiveField(6)
  DateTime? lastCompletedDate;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  int bestStreak;

  @HiveField(9)
  int totalCompletions;

  Streak({
    required this.id,
    required this.name,
    this.emoji = '⚡',
    this.description = '',
    this.steps = const [],
    this.currentStreak = 0,
    this.lastCompletedDate,
    required this.createdAt,
    this.bestStreak = 0,
    this.totalCompletions = 0,
  });

  /// Check if the streak can be completed today
  bool canCompleteToday() {
    if (lastCompletedDate == null) return true;
    
    final now = DateTime.now();
    final lastCompleted = lastCompletedDate!;
    
    // Check if it's a different day
    return now.year != lastCompleted.year ||
        now.month != lastCompleted.month ||
        now.day != lastCompleted.day;
  }

  /// Check if the streak is broken (missed yesterday)
  bool isStreakBroken() {
    if (lastCompletedDate == null) return false;
    
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final lastCompleted = lastCompletedDate!;
    
    // If last completion was not today or yesterday, streak is broken
    final isSameAsToday = now.year == lastCompleted.year &&
        now.month == lastCompleted.month &&
        now.day == lastCompleted.day;
    
    final isSameAsYesterday = yesterday.year == lastCompleted.year &&
        yesterday.month == lastCompleted.month &&
        yesterday.day == lastCompleted.day;
    
    return !isSameAsToday && !isSameAsYesterday;
  }

  /// Complete the streak for today
  void complete() {
    final now = DateTime.now();
    
    // Check if streak should be reset
    if (isStreakBroken()) {
      currentStreak = 0;
    }
    
    if (canCompleteToday()) {
      currentStreak++;
      totalCompletions++;
      lastCompletedDate = now;
      
      if (currentStreak > bestStreak) {
        bestStreak = currentStreak;
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'description': description,
      'steps': steps,
      'currentStreak': currentStreak,
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'bestStreak': bestStreak,
      'totalCompletions': totalCompletions,
    };
  }

  factory Streak.fromJson(Map<String, dynamic> json) {
    return Streak(
      id: json['id'],
      name: json['name'],
      emoji: json['emoji'] ?? '⚡',
      description: json['description'] ?? '',
      steps: List<String>.from(json['steps'] ?? []),
      currentStreak: json['currentStreak'] ?? 0,
      lastCompletedDate: json['lastCompletedDate'] != null
          ? DateTime.parse(json['lastCompletedDate'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      bestStreak: json['bestStreak'] ?? 0,
      totalCompletions: json['totalCompletions'] ?? 0,
    );
  }
}

