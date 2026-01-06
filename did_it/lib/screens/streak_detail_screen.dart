import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/streak.dart';
import '../services/streak_service.dart';
import '../theme/app_theme.dart';

class StreakDetailScreen extends StatelessWidget {
  final Streak streak;
  final StreakService streakService;

  const StreakDetailScreen({
    super.key,
    required this.streak,
    required this.streakService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Streak Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Streak name
          Text(
            streak.name,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          
          if (streak.description != null && streak.description!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              streak.description!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ],
          
          const SizedBox(height: 48),
          
          // Current streak count (very prominent)
          Center(
            child: Column(
              children: [
                Text(
                  '${streak.currentStreak}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 96,
                        fontWeight: FontWeight.w700,
                        color: streak.isCompletedToday
                            ? AppTheme.successGreen
                            : AppTheme.textPrimary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  streak.currentStreak == 1 ? 'day' : 'days',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 48),
          
          // Completed today indicator
          if (streak.isCompletedToday)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.successGreen.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppTheme.successGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Completed today',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.successGreen,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          
          const SizedBox(height: 48),
          
          // Stats section
          _buildStatCard(
            context,
            'Last Completed',
            streak.lastCompletedDate != null
                ? _formatDate(streak.lastCompletedDate!)
                : 'Never',
          ),
          
          const SizedBox(height: 16),
          
          _buildStatCard(
            context,
            'Started',
            _formatDate(streak.createdAt),
          ),
          
          const SizedBox(height: 16),
          
          _buildStatCard(
            context,
            'Total Days',
            _calculateTotalDays().toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(date.year, date.month, date.day);
    final difference = today.difference(dateToCheck).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return DateFormat('EEEE').format(date);
    } else {
      return DateFormat('MMM d, y').format(date);
    }
  }

  int _calculateTotalDays() {
    final now = DateTime.now();
    final created = streak.createdAt;
    return now.difference(created).inDays + 1;
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Streak'),
        content: Text(
          'Are you sure you want to delete "${streak.name}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await streakService.deleteStreak(streak.id);
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to home
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

