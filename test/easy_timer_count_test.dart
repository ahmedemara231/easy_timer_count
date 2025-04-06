import 'package:easy_timer_count/easy_timer_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EasyTime class tests', () {
    test('toSeconds conversion works correctly', () {
      // Test with hours, minutes, seconds
      const time1 = EasyTime(hours: 2, minutes: 30, seconds: 15);
      expect(time1.toSeconds, equals(2 * 3600 + 30 * 60 + 15));

      // Test with default values (zeros)
      const time2 = EasyTime();
      expect(time2.toSeconds, equals(0));

      // Test with only minutes
      const time3 = EasyTime(minutes: 5);
      expect(time3.toSeconds, equals(5 * 60));
    });
  });

  group('EasyTimerCount widget tests', () {
    late EasyTimerController controller;
    int startCount = 0;
    int endCount = 0;
    int restartCount = 0;

    setUp(() {
      controller = EasyTimerController();
      startCount = 0;
      endCount = 0;
      restartCount = 0;
    });

    testWidgets('Basic timer countdown works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyTimerCount(
              duration: const EasyTime(seconds: 5),
              rankingType: RankingType.descending,
              onTimerStarts: () => startCount++,
              onTimerEnds: () => endCount++,
              controller: controller,
            ),
          ),
        ),
      );

      // Check initial state - should show "00:05"
      expect(find.text('00:05'), findsOneWidget);
      expect(startCount, 1);

      // After 1 second
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('00:04'), findsOneWidget);

      // After 2 more seconds
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('00:02'), findsOneWidget);

      // After 2 more seconds
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('00:00'), findsOneWidget);

      // After another second, timer should end
      await tester.pump(const Duration(seconds: 1));
      expect(endCount, 1);
    });

    testWidgets('Timer with ascending works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyTimerCount(
              duration: const EasyTime(seconds: 5),
              rankingType: RankingType.ascending,
              onTimerStarts: () => startCount++,
              onTimerEnds: () => endCount++,
              controller: controller,
            ),
          ),
        ),
      );

      // Check initial state - should show "00:00"
      expect(find.text('00:00'), findsOneWidget);

      // After 1 second
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('00:01'), findsOneWidget);

      // After 4 more seconds
      await tester.pump(const Duration(seconds: 4));
      expect(find.text('00:05'), findsOneWidget);

      // After another second, timer should end
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('00:06'), findsOneWidget);
      expect(endCount, 1);
    });

    testWidgets('Timer controller functionality test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyTimerCount(
              duration: const EasyTime(seconds: 10),
              rankingType: RankingType.descending,
              onTimerStarts: () => startCount++,
              onTimerEnds: () => endCount++,
              controller: controller,
            ),
          ),
        ),
      );

      // Check initial state
      expect(find.text('00:10'), findsOneWidget);

      // After 2 seconds
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('00:08'), findsOneWidget);

      // Stop the timer
      controller.stop();
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('00:08'), findsOneWidget); // Time shouldn't change

      // Resume the timer
      controller.resume();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('00:07'), findsOneWidget);

      // Reset the timer
      controller.reset();
      await tester.pump();
      expect(find.text('00:10'), findsOneWidget);
    });

    testWidgets('Timer with repeat functionality', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyTimerCount.repeat(
              duration: const EasyTime(seconds: 3),
              rankingType: RankingType.descending,
              onTimerStarts: () => startCount++,
              onTimerEnds: () => endCount++,
              onTimerRestart: (count) => restartCount = count,
              controller: controller,
            ),
          ),
        ),
      );

      // Check initial state
      expect(find.text('00:03'), findsOneWidget);
      expect(startCount, 1);

      // After 3 seconds, timer should end and restart
      await tester.pump(const Duration(seconds: 3));
      expect(find.text('00:00'), findsOneWidget);

      // After another second, timer should restart
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('00:03'), findsOneWidget);
      expect(restartCount, 1);
      expect(startCount, 2);
      expect(endCount, 1);
    });

    testWidgets('Timer with custom separator', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyTimerCount(
              duration: const EasyTime(seconds: 5),
              rankingType: RankingType.descending,
              onTimerStarts: () => startCount++,
              onTimerEnds: () => endCount++,
              separatorType: SeparatorType.dashed,
              controller: controller,
            ),
          ),
        ),
      );

      // Check initial state with dashed separator
      expect(find.text('00-05'), findsOneWidget);
    });

    testWidgets('Timer with hours format', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyTimerCount(
              duration: const EasyTime(hours: 1, minutes: 2, seconds: 3),
              rankingType: RankingType.descending,
              onTimerStarts: () => startCount++,
              onTimerEnds: () => endCount++,
              controller: controller,
            ),
          ),
        ),
      );

      // Check initial state with hours format (HH:MM:SS)
      expect(find.text('01:02:03'), findsOneWidget);
    });

    testWidgets('Timer with custom builder', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyTimerCount.builder(
              duration: const EasyTime(seconds: 5),
              rankingType: RankingType.descending,
              onTimerStarts: () => startCount++,
              onTimerEnds: () => endCount++,
              builder: (String time) => Container(
                padding: const EdgeInsets.all(8),
                color: Colors.blue,
                child: Text('Time: $time', style: const TextStyle(color: Colors.white)),
              ),
              controller: controller,
            ),
          ),
        ),
      );

      // Check custom builder output
      expect(find.text('Time: 00:05'), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });
  });
}