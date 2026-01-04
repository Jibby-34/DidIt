import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../services/subscription_service.dart';
import '../theme/app_theme.dart';
import '../widgets/decorative_background.dart';
import 'premium_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isPremium = false;
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final isPremium = await StorageService.isPremium();
    setState(() {
      _isPremium = isPremium;
      // Notifications setting would come from SharedPreferences
      _notificationsEnabled = false;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    if (value) {
      final granted = await NotificationService.requestPermissions();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification permission denied'),
            ),
          );
        }
        return;
      }
    }

    setState(() {
      _notificationsEnabled = value;
    });

    // Save preference and schedule/cancel notifications
    // This would be expanded with SharedPreferences
  }

  Future<void> _restorePurchases() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppTheme.electricBlue),
      ),
    );

    await SubscriptionService.restorePurchases();

    if (!mounted) return;
    
    Navigator.pop(context);
    await _loadSettings();
    
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                _isPremium ? Icons.flash_on : Icons.info_outline,
                color: AppTheme.electricBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _isPremium
                    ? 'Premium restored!'
                    : 'No purchases found',
              ),
            ],
          ),
          backgroundColor: _isPremium ? AppTheme.electricBlue : AppTheme.cardBackgroundElevated,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
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
                        Icon(Icons.settings, color: AppTheme.electricBlue, size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'Settings',
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
                child: ListView(
        children: [
          // Premium Section
          if (!_isPremium) ...[
            Card(
              margin: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PremiumScreen(),
                    ),
                  );
                  
                  if (result == true) {
                    await _loadSettings();
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.flash_on, color: AppTheme.darkBackground, size: 28),
                          const SizedBox(width: 8),
                          const Text(
                            'Upgrade to Premium',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.darkBackground,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Unlimited streaks • No ads • Instant AI',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkBackground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.verified,
                        color: AppTheme.electricBlue,
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.flash_on, color: AppTheme.electricBlue, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  'Premium Active',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                            Text(
                              'Thank you for your support!',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

          // Notifications Section
          const Padding(
            padding: EdgeInsets.fromLTRB(32, 16, 32, 8),
            child: Text(
              'NOTIFICATIONS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SwitchListTile(
              title: const Text('Daily Reminders'),
              subtitle: const Text('Get reminded to complete your streaks'),
              value: _notificationsEnabled,
              activeColor: AppTheme.electricBlue,
              activeTrackColor: AppTheme.electricBlue.withValues(alpha: 0.5),
              onChanged: _toggleNotifications,
            ),
          ),

          // Account Section
          const Padding(
            padding: EdgeInsets.fromLTRB(32, 24, 32, 8),
            child: Text(
              'ACCOUNT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.restore),
              title: const Text('Restore Purchases'),
              subtitle: const Text('Restore your premium subscription'),
              onTap: _restorePurchases,
            ),
          ),

          // About Section
          const Padding(
            padding: EdgeInsets.fromLTRB(32, 24, 32, 8),
            child: Text(
              'ABOUT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Version'),
                  trailing: const Text('1.0.0'),
                ),
                ListTile(
                  leading: Icon(Icons.flash_on, color: AppTheme.electricBlue),
                  title: Row(
                    children: [
                      const Text('Made with '),
                      Icon(Icons.flash_on, color: AppTheme.electricBlue, size: 18),
                    ],
                  ),
                  subtitle: const Text('Built with Flutter'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
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

