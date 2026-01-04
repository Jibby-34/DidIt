import 'package:flutter/material.dart';
import '../services/subscription_service.dart';
import '../services/storage_service.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool _isProcessing = false;

  Future<void> _purchasePremium() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final success = await SubscriptionService.purchaseSubscription();

      if (success && mounted) {
        // Check if premium was granted
        final isPremium = await StorageService.isPremium();
        
        if (isPremium) {
          if (mounted) {
            Navigator.pop(context, true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('⚡ Welcome to Premium!'),
                backgroundColor: AppTheme.neonGreen,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Purchase failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚡ Premium'),
      ),
      body: _isProcessing
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppTheme.electricYellow),
                  SizedBox(height: 24),
                  Text('Processing...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '⚡',
                    style: TextStyle(fontSize: 80),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Unlock Premium',
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Supercharge your streak tracking',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Features
                  _buildFeature(
                    icon: Icons.all_inclusive,
                    title: 'Unlimited Streaks',
                    description: 'Create as many streaks as you want',
                  ),
                  const SizedBox(height: 20),
                  _buildFeature(
                    icon: Icons.block,
                    title: 'No Ads',
                    description: 'Ad-free experience, forever',
                  ),
                  const SizedBox(height: 20),
                  _buildFeature(
                    icon: Icons.flash_on,
                    title: 'Instant AI Setup',
                    description: 'Get personalized streak suggestions instantly',
                  ),
                  const SizedBox(height: 20),
                  _buildFeature(
                    icon: Icons.favorite,
                    title: 'Support Development',
                    description: 'Help us build more awesome features',
                  ),

                  const SizedBox(height: 48),

                  // Price
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppTheme.electricYellow,
                          AppTheme.neonGreen,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '\$${AppConstants.subscriptionPriceMonthly.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkBackground,
                          ),
                        ),
                        const Text(
                          'per month',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppTheme.darkBackground,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Purchase button
                  ElevatedButton(
                    onPressed: _purchasePremium,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    child: const Text(
                      'Subscribe Now',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Subscription auto-renews monthly. Cancel anytime.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  TextButton(
                    onPressed: () {
                      // TODO: Show terms of service
                    },
                    child: const Text('Terms of Service'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFeature({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.electricYellow.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.electricYellow,
              width: 2,
            ),
          ),
          child: Icon(
            icon,
            color: AppTheme.electricYellow,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

