import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../services/subscription_service.dart';
import '../theme/app_theme.dart';
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
        child: CircularProgressIndicator(color: AppTheme.electricYellow),
      ),
    );

    await SubscriptionService.restorePurchases();

    if (!mounted) return;
    
    Navigator.pop(context);
    await _loadSettings();
    
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isPremium
                ? '⚡ Premium restored!'
                : 'No purchases found',
          ),
          backgroundColor:
              _isPremium ? AppTheme.neonGreen : null,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
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
                borderRadius: BorderRadius.circular(16),
                child: Container(
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
                  child: const Column(
                    children: [
                      Text(
                        '⚡ Upgrade to Premium',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkBackground,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Unlimited streaks • No ads • Instant AI',
                        style: TextStyle(
                          fontSize: 14,
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
                        color: AppTheme.neonGreen,
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '⚡ Premium Active',
                              style: Theme.of(context).textTheme.titleLarge,
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
            child:             SwitchListTile(
              title: const Text('Daily Reminders'),
              subtitle: const Text('Get reminded to complete your streaks'),
              value: _notificationsEnabled,
              activeTrackColor: AppTheme.electricYellow,
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
                  leading: const Icon(Icons.bolt),
                  title: const Text('Made with ⚡'),
                  subtitle: const Text('Built with Flutter'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

