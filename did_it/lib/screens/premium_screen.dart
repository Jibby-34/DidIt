import 'package:flutter/material.dart';
import '../services/subscription_service.dart';
import '../services/storage_service.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import '../widgets/decorative_background.dart';

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
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.flash_on, color: AppTheme.electricBlue, size: 20),
                    const SizedBox(width: 8),
                    const Text('Welcome to Premium!'),
                  ],
                ),
                backgroundColor: AppTheme.electricBlue,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
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
    return DecorativeBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Custom Header
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.electricBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.electricBlue.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppTheme.electricBlue,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        Icon(Icons.flash_on, color: AppTheme.electricBlue, size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'Premium',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: _isProcessing
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: AppTheme.electricBlue),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.flash_on, color: AppTheme.electricBlue, size: 20),
                      const SizedBox(width: 8),
                      const Text('Processing...'),
                    ],
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      size: 80,
                    ),
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
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.electricBlue,
                          AppTheme.electricBlueDark,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.electricBlue.withValues(alpha: 0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
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
                            fontWeight: FontWeight.w600,
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
              ),
            ],
          ),
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
            gradient: LinearGradient(
              colors: [
                AppTheme.electricBlue.withValues(alpha: 0.2),
                AppTheme.electricBlue.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.electricBlue,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.electricBlue.withValues(alpha: 0.3),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Icon(
            icon,
            color: AppTheme.electricBlue,
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

