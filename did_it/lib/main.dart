import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/streak_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize streak service
  final streakService = StreakService();
  await streakService.init();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppTheme.background,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(DidItApp(streakService: streakService));
}

class DidItApp extends StatelessWidget {
  final StreakService streakService;

  const DidItApp({super.key, required this.streakService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Did It',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: HomeScreen(streakService: streakService),
    );
  }
}
