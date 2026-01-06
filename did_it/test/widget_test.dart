// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:did_it/main.dart';
import 'package:did_it/services/streak_service.dart';

void main() {
  testWidgets('Did It app smoke test', (WidgetTester tester) async {
    // Initialize streak service
    final streakService = StreakService();
    await streakService.init();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(DidItApp(streakService: streakService));

    // Verify that the app title is present
    expect(find.text('Did It'), findsOneWidget);
    
    // Verify empty state is shown
    expect(find.text('No streaks yet'), findsOneWidget);
  });
}
