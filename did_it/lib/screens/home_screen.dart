import 'package:flutter/material.dart';
import '../models/streak.dart';
import '../services/streak_service.dart';
import '../theme/app_theme.dart';
import 'create_streak_screen.dart';
import 'streak_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final StreakService streakService;

  const HomeScreen({super.key, required this.streakService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Did It'),
      ),
      body: StreamBuilder<List<Streak>>(
        stream: widget.streakService.watchStreaks(),
        initialData: widget.streakService.getAllStreaks(),
        builder: (context, snapshot) {
          final streaks = snapshot.data ?? [];

          if (streaks.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 16, bottom: 100),
            itemCount: streaks.length,
            itemBuilder: (context, index) {
              return _buildStreakCard(context, streaks[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreateStreak(context),
        backgroundColor: AppTheme.textPrimary,
        foregroundColor: AppTheme.background,
        icon: const Icon(Icons.add, size: 24),
        label: const Text(
          'New Streak',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: AppTheme.textSecondary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'No streaks yet',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Create your first streak to start building a habit',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context, Streak streak) {
    final isCompleted = streak.isCompletedToday;

    return Card(
      child: InkWell(
        onTap: () => _handleStreakTap(streak),
        onLongPress: () => _showDeleteDialog(context, streak),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Checkmark indicator
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppTheme.successGreen
                      : AppTheme.background,
                  border: Border.all(
                    color: isCompleted
                        ? AppTheme.successGreen
                        : AppTheme.divider,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 28,
                        weight: 700,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              
              // Streak info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      streak.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${streak.currentStreak} ${streak.currentStreak == 1 ? 'day' : 'days'}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              
              // Navigation arrow
              IconButton(
                onPressed: () => _navigateToDetail(context, streak),
                icon: const Icon(Icons.chevron_right),
                color: AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleStreakTap(Streak streak) async {
    if (streak.isCompletedToday) {
      // Do nothing - already completed today
      return;
    }

    await widget.streakService.markStreakComplete(streak.id);
    setState(() {});
  }

  void _navigateToCreateStreak(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateStreakScreen(
          streakService: widget.streakService,
        ),
      ),
    );
    setState(() {});
  }

  void _navigateToDetail(BuildContext context, Streak streak) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StreakDetailScreen(
          streak: streak,
          streakService: widget.streakService,
        ),
      ),
    );
    setState(() {});
  }

  void _showDeleteDialog(BuildContext context, Streak streak) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Streak'),
        content: Text('Are you sure you want to delete "${streak.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await widget.streakService.deleteStreak(streak.id);
              if (context.mounted) {
                Navigator.pop(context);
                setState(() {});
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

