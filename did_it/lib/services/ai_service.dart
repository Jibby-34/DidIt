import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class AiService {
  /// Generate streak details using AI
  static Future<AiStreakResult?> generateStreakDetails(String streakName) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.aiWorkerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'type': 'streak_setup',
          'streakName': streakName,
          'tone': 'motivating',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AiStreakResult.fromJson(data);
      } else {
        // AI service error, will use fallback
        return null;
      }
    } catch (e) {
      // AI service exception, will use fallback
      return null;
    }
  }

  /// Fallback for when AI is unavailable or user is offline
  static AiStreakResult getFallbackResult(String streakName) {
    return AiStreakResult(
      emoji: '⚡',
      description: 'Build your $streakName streak, one day at a time.',
      steps: [
        'Start small and stay consistent',
        'Track your progress daily',
        'Celebrate every milestone',
      ],
    );
  }
}

class AiStreakResult {
  final String emoji;
  final String description;
  final List<String> steps;

  AiStreakResult({
    required this.emoji,
    required this.description,
    required this.steps,
  });

  factory AiStreakResult.fromJson(Map<String, dynamic> json) {
    return AiStreakResult(
      emoji: json['emoji'] ?? '⚡',
      description: json['description'] ?? '',
      steps: List<String>.from(json['steps'] ?? []),
    );
  }
}

