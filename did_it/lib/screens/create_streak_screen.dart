import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/streak.dart';
import '../providers/streak_provider.dart';
import '../services/ai_service.dart';
import '../services/ads_service.dart';
import '../services/storage_service.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import 'premium_screen.dart';

class CreateStreakScreen extends StatefulWidget {
  const CreateStreakScreen({super.key});

  @override
  State<CreateStreakScreen> createState() => _CreateStreakScreenState();
}

class _CreateStreakScreenState extends State<CreateStreakScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  bool _isLoading = false;
  bool _canCreate = true;
  bool _isPremium = false;

  @override
  void initState() {
    super.initState();
    _checkCreatePermission();
  }

  Future<void> _checkCreatePermission() async {
    final isPremium = await StorageService.isPremium();
    final canCreate = await StorageService.canCreateStreak(
      AppConstants.maxFreeStreaks,
    );
    
    setState(() {
      _isPremium = isPremium;
      _canCreate = canCreate;
    });
  }

  Future<void> _handleWatchAd() async {
    if (!AdsService.isRewardedAdReady()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ad not ready yet. Please try again in a moment.'),
        ),
      );
      return;
    }

    final earned = await AdsService.showRewardedAd();
    
    if (earned && mounted) {
      setState(() {
        _canCreate = true;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚡ Unlocked! You can now create a streak.'),
          backgroundColor: AppTheme.neonGreen,
        ),
      );
    }
  }

  Future<void> _createStreak() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final streakName = _nameController.text.trim();
    
    // Call AI service
    AiStreakResult? aiResult = await AiService.generateStreakDetails(streakName);
    
    // Use fallback if AI fails
    aiResult ??= AiService.getFallbackResult(streakName);

    // Create streak
    final streak = Streak(
      id: const Uuid().v4(),
      name: streakName,
      emoji: aiResult.emoji,
      description: aiResult.description,
      steps: aiResult.steps,
      createdAt: DateTime.now(),
    );

    if (!mounted) return;
    
    await context.read<StreakProvider>().addStreak(streak);

    if (!mounted) return;
    
    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Streak'),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppTheme.electricYellow),
                  SizedBox(height: 24),
                  Text('⚡ Charging your streak...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '⚡',
                      style: TextStyle(fontSize: 60),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'What do you want to track?',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    // Streak name input
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., Study Japanese, Workout, Read',
                        labelText: 'Streak Name',
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a streak name';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 32),

                    // Create button or limit message
                    if (!_canCreate && !_isPremium) ...[
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.electricYellow,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              '⚡ Free Limit Reached',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.electricYellow,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'You\'ve created ${AppConstants.maxFreeStreaks} streaks. Watch an ad to create more, or upgrade to Premium!',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: _handleWatchAd,
                              icon: const Icon(Icons.play_circle_outline),
                              label: const Text('Watch Ad to Unlock'),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PremiumScreen(),
                                  ),
                                );
                                
                                if (result == true) {
                                  await _checkCreatePermission();
                                }
                              },
                              child: const Text('Upgrade to Premium'),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      ElevatedButton(
                        onPressed: _createStreak,
                        child: const Text('Create Streak'),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Text(
                        'AI will suggest motivating steps and an emoji for your streak',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],

                    if (!_isPremium) ...[
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppTheme.electricYellow,
                              AppTheme.neonGreen,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              '⚡ Go Premium',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkBackground,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Unlimited streaks, no ads, instant AI setup',
                              style: TextStyle(
                                color: AppTheme.darkBackground,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${AppConstants.subscriptionPriceMonthly}/month',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkBackground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}

