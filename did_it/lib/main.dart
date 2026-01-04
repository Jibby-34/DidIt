import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/storage_service.dart';
import 'services/ads_service.dart';
import 'services/notification_service.dart';
import 'providers/streak_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await StorageService.init();
  await AdsService.init();
  await NotificationService.init();

  // Preload first rewarded ad
  AdsService.loadRewardedAd();

  runApp(const DidItApp());
}

class DidItApp extends StatelessWidget {
  const DidItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StreakProvider()),
      ],
      child: MaterialApp(
        title: 'Did It',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
