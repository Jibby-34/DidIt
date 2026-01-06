import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import '../models/streak.dart';

class StreakService {
  static const String _boxName = 'streaks';
  late Box<Streak> _box;
  final _uuid = const Uuid();

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(StreakAdapter());
    
    try {
      _box = await Hive.openBox<Streak>(_boxName);
    } catch (e) {
      // If there's an error opening the box (e.g., from corrupted data),
      // manually delete the files and create a fresh box
      print('Error opening Hive box: $e');
      print('Deleting corrupted data and creating fresh box...');
      
      try {
        // Close any open boxes
        if (Hive.isBoxOpen(_boxName)) {
          await Hive.box<Streak>(_boxName).close();
        }
      } catch (_) {}
      
      try {
        // Manually delete box files
        final appDocDir = await getApplicationDocumentsDirectory();
        final boxPath = '${appDocDir.path}/$_boxName.hive';
        final lockPath = '${appDocDir.path}/$_boxName.lock';
        
        final boxFile = File(boxPath);
        final lockFile = File(lockPath);
        
        if (await boxFile.exists()) {
          await boxFile.delete();
        }
        if (await lockFile.exists()) {
          await lockFile.delete();
        }
      } catch (deleteError) {
        print('Error deleting files: $deleteError');
      }
      
      // Create a fresh box
      _box = await Hive.openBox<Streak>(_boxName);
    }
  }

  List<Streak> getAllStreaks() {
    return _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> createStreak({
    required String name,
    String? description,
  }) async {
    final streak = Streak(
      id: _uuid.v4(),
      name: name,
      description: description,
      currentStreak: 0,
      lastCompletedDate: null,
      createdAt: DateTime.now(),
    );
    await _box.put(streak.id, streak);
  }

  Future<void> updateStreak(Streak streak) async {
    await _box.put(streak.id, streak);
  }

  Future<void> deleteStreak(String id) async {
    await _box.delete(id);
  }

  Future<void> markStreakComplete(String id) async {
    final streak = _box.get(id);
    if (streak != null && !streak.isCompletedToday) {
      streak.markComplete();
      await updateStreak(streak);
    }
  }

  Streak? getStreak(String id) {
    return _box.get(id);
  }

  // Get live updates for streaks
  Stream<List<Streak>> watchStreaks() {
    return _box.watch().map((_) => getAllStreaks());
  }
}

