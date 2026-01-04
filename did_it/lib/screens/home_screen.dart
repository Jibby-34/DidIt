import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/streak_provider.dart';
import '../models/streak.dart';
import '../widgets/lightning_animation.dart';
import '../widgets/decorative_background.dart';
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
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.flash_on, color: AppTheme.electricBlue, size: 20),
              const SizedBox(width: 8),
              const Text('Already completed today!'),
            ],
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: AppTheme.cardBackgroundElevated,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
          content: Row(
            children: [
              Icon(Icons.flash_on, color: AppTheme.electricBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                '${streak.currentStreak + 1} day streak! Keep it up!',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: AppTheme.electricBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecorativeBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Consumer<StreakProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.electricBlue,
                    strokeWidth: 3,
                  ),
                );
              }

              return CustomScrollView(
                slivers: [
                  // Simple Header with logo and settings
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                padding: const EdgeInsets.all(4),
                                child: Image.asset(
                                  'assets/icons/didit_logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'DidIt',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.settings_outlined,
                              color: AppTheme.textSecondary,
                              size: 24,
                            ),
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
                    ),
                  ),
                  // Streaks List or Empty State
                  if (provider.streaks.isEmpty)
                    SliverFillRemaining(
                      child: _buildEmptyState(context),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final streak = provider.streaks[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildStreakCard(context, streak),
                            );
                          },
                          childCount: provider.streaks.length,
                        ),
                      ),
                    ),
                  // Bottom spacing
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 80),
                  ),
                ],
              );
            },
          ),
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
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.electricBlue.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Icon(
                Icons.flash_on,
                color: AppTheme.electricBlue,
                size: 100,
              ),
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

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.cardBackgroundElevated,
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
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
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(width: 16),
                    // Streak info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            streak.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (isBroken && streak.currentStreak > 0)
                            Text(
                              'Streak broken',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            )
                          else if (canComplete)
                            const Text(
                              'Tap to complete',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                            )
                          else
                            const Text(
                              'Completed',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.electricBlue,
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
                        color: AppTheme.electricBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.electricBlue.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${streak.currentStreak}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.electricBlue,
                            ),
                          ),
                          const Text(
                            'days',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.textSecondary,
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
    );
  }
}

