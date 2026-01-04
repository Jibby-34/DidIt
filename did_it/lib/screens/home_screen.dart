import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/streak_provider.dart';
import '../models/streak.dart';
import '../widgets/lightning_animation.dart';
import '../theme/app_theme.dart';
import 'create_streak_screen.dart';
import 'streak_detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _animatingStreakId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StreakProvider>().loadStreaks();
    });
  }

  Future<void> _handleStreakTap(Streak streak) async {
    if (!streak.canCompleteToday()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚡ Already completed today!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _animatingStreakId = streak.id;
    });

    await context.read<StreakProvider>().completeStreak(streak.id);

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _animatingStreakId = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '⚡ ${streak.currentStreak + 1} day streak! Keep it up!',
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: AppTheme.electricYellow,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('⚡ '),
            Text('Did It'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<StreakProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.electricYellow,
              ),
            );
          }

          if (provider.streaks.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadStreaks(),
            color: AppTheme.electricYellow,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.streaks.length,
              itemBuilder: (context, index) {
                final streak = provider.streaks[index];
                return _buildStreakCard(context, streak);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateStreakScreen(),
            ),
          );
          
          if (result == true) {
            if (context.mounted) {
              context.read<StreakProvider>().loadStreaks();
            }
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('New Streak'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '⚡',
              style: TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 24),
            Text(
              'No Streaks Yet',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Create your first streak to start building momentum!',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateStreakScreen(),
                  ),
                );
                
                if (result == true && context.mounted) {
                  context.read<StreakProvider>().loadStreaks();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Streak'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context, Streak streak) {
    final isAnimating = _animatingStreakId == streak.id;
    final canComplete = streak.canCompleteToday();
    final isBroken = streak.isStreakBroken();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          LightningGlow(
            isActive: canComplete && !isAnimating,
            child: Card(
              child: InkWell(
                onTap: () => _handleStreakTap(streak),
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StreakDetailScreen(streak: streak),
                    ),
                  );
                },
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
            ),
          ),
          if (isAnimating)
            const Positioned.fill(
              child: Center(
                child: LightningAnimation(size: 120),
              ),
            ),
        ],
      ),
    );
  }
}

