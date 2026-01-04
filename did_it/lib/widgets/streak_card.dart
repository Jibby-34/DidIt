import 'package:flutter/material.dart';
import '../models/streak.dart';
import '../theme/app_theme.dart';

/// Reusable streak card widget
class StreakCard extends StatelessWidget {
  final Streak streak;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showAnimation;

  const StreakCard({
    super.key,
    required this.streak,
    this.onTap,
    this.onLongPress,
    this.showAnimation = false,
  });

  @override
  Widget build(BuildContext context) {
    final canComplete = streak.canCompleteToday();
    final isBroken = streak.isStreakBroken();

    return Card(
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              // Emoji
              Text(
                streak.emoji,
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(width: 20),
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
                    if (isBroken && streak.currentStreak > 0)
                      Text(
                        'Streak broken! Restart today',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.redAccent,
                            ),
                      )
                    else if (canComplete)
                      Text(
                        'Tap to complete today',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.electricYellow,
                            ),
                      )
                    else
                      Text(
                        '✓ Completed today',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.neonGreen,
                            ),
                      ),
                  ],
                ),
              ),
              // Streak count
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.electricYellow.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.electricYellow,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '${streak.currentStreak}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.electricYellow,
                      ),
                    ),
                    Text(
                      'days',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.electricYellow,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

