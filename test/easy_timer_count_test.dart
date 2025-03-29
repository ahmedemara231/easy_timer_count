import 'package:easy_timer_count/easy_timer_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EasyTimerCount Widget Tests', () {
    late EasyTimerController controller;
    int timerStartCalls = 0;
    int timerEndCalls = 0;
    int timerRestartCalls = 0;
    int restartCount = 0;

    setUp(() {
      controller = EasyTimerController();
      timerStartCalls = 0;
      timerEndCalls = 0;
      timerRestartCalls = 0;
      restartCount = 0;
    });

    testWidgets('Default constructor renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyTimerCount(
              controller: controller,
              duration: const EasyTime(seconds: 10),
              rankingType: RankingType.descending,
              onTimerStarts: () => timerStartCalls++,
              onTimerEnds: () => timerEndCalls++,
            ),
          ),
        ),
      );

      expect(find.byType(EasyTimerCount), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
      expect(timerStartCalls, equals(1)); // Timer should start automatically
    });

    testWidgets('Custom constructor renders with builder', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyTimerCount.custom(
              controller: controller,
              duration: const EasyTime(seconds: 10),
              rankingType: RankingType.descending,
              onTimerStarts: () => timerStartCalls++,
              onTimerEnds: () => timerEndCalls++,
              builder: (time) => Container(
                color: Colors.blue,
                child: Text('Custom: $time'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(EasyTimerCount), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.textContaining('Custom:'), findsOneWidget);
      expect(timerStartCalls, equals(1));
    });

    testWidgets('Repeat constructor works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyTimerCount.repeat(
              controller: controller,
              duration: const EasyTime(seconds: 2),
              rankingType: RankingType.descending,
              onTimerStarts: () => timerStartCalls++,
              onTimerEnds: () => timerEndCalls++,
              onTimerRestart: (count) {
                timerRestartCalls++;
                restartCount = count;
              },
            ),
          ),
        ),
      );

      expect(find.byType(EasyTimerCount), findsOneWidget);

      // Wait for timer to complete and restart
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      expect(timerStartCalls, equals(2)); // Initial start + restart
      expect(timerEndCalls, equals(1));
      expect(timerRestartCalls, equals(1));
      expect(restartCount, equals(1));
    });

    testWidgets('RepeatCustom constructor works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyTimerCount.repeatCustom(
              controller: controller,
              duration: const EasyTime(seconds: 2),
              rankingType: RankingType.descending,
              onTimerStarts: () => timerStartCalls++,
              onTimerEnds: () => timerEndCalls++,
              onTimerRestart: (count) {
                timerRestartCalls++;
                restartCount = count;
              },
              builder: (time) => Text('Custom Repeat: $time'),
            ),
          ),
        ),
      );

      expect(find.byType(EasyTimerCount), findsOneWidget);
      expect(find.textContaining('Custom Repeat:'), findsOneWidget);

      // Wait for timer to complete and restart
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      expect(timerStartCalls, equals(2));
      expect(timerEndCalls, equals(1));
      expect(timerRestartCalls, equals(1));
    });

    testWidgets('Timer formats time correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyTimerCount(
              controller: controller,
              duration: const EasyTime(seconds: 65),
              rankingType: RankingType.descending,
              onTimerStarts: () => timerStartCalls++,
              onTimerEnds: () => timerEndCalls++,
            ),
          ),
        ),
      );

      // Initially should be 01:05
      expect(find.text('01:05'), findsOneWidget);

      // After 1 second should be 01:04
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('01:04'), findsOneWidget);
    });

    testWidgets('Separator types work correctly', (WidgetTester tester) async {
      // Test with dashed separator
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyTimerCount(
              controller: controller,
              duration: const EasyTime(seconds: 65),
              rankingType: RankingType.descending,
              onTimerStarts: () => timerStartCalls++,
              onTimerEnds: () => timerEndCalls++,
              separatorType: SeparatorType.dashed,
            ),
          ),
        ),
      );

      expect(find.text('01-05'), findsOneWidget);

      // Test with no separator
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyTimerCount(
              controller: controller,
              duration: const EasyTime(seconds: 65),
              rankingType: RankingType.descending,
              onTimerStarts: () => timerStartCalls++,
              onTimerEnds: () => timerEndCalls++,
              separatorType: SeparatorType.none,
            ),
          ),
        ),
      );

      await tester.pump(); // Allow widget to rebuild
      expect(find.text('0105'), findsOneWidget);
    });

    testWidgets('RankingType.ascending works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyTimerCount(
              controller: controller,
              duration: const EasyTime(seconds: 5),
              rankingType: RankingType.ascending,
              onTimerStarts: () => timerStartCalls++,
              onTimerEnds: () => timerEndCalls++,
            ),
          ),
        ),
      );

      // Initially should be 00:00
      expect(find.text('00:00'), findsOneWidget);

      // After 2 seconds
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('00:02'), findsOneWidget);

      // After another 3 seconds it should reach the end
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      expect(timerEndCalls, equals(1));
    });

    testWidgets('Controller can stop timer', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyTimerCount(
              controller: controller,
              duration: const EasyTime(seconds: 10),
              rankingType: RankingType.descending,
              onTimerStarts: () => timerStartCalls++,
              onTimerEnds: () => timerEndCalls++,
            ),
          ),
        ),
      );

      // Initially should be 00:10
      expect(find.text('00:10'), findsOneWidget);

      // After 2 seconds
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('00:08'), findsOneWidget);

      // Stop the timer
      controller.stop();

      // After another 2 seconds, it should still show 00:08
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('00:08'), findsOneWidget);
    });

    testWidgets('Controller can resume timer', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyTimerCount(
              controller: controller,
              duration: const EasyTime(seconds: 10),
              rankingType: RankingType.descending,
              onTimerStarts: () => timerStartCalls++,
              onTimerEnds: () => timerEndCalls++,
            ),
          ),
        ),
      );

      // After 2 seconds
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('00:08'), findsOneWidget);

      // Stop the timer
      controller.stop();

      // After another 2 seconds, it should still show 00:08
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('00:08'), findsOneWidget);

      // Resume the timer
      controller.resume();

      // After another second, it should show 00:07
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('00:07'), findsOneWidget);
    });

    testWidgets('Timer with hours formats correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyTimerCount(
              controller: controller,
              duration: const EasyTime(hours: 1, minutes: 5, seconds: 10),
              rankingType: RankingType.descending,
              onTimerStarts: () => timerStartCalls++,
              onTimerEnds: () => timerEndCalls++,
            ),
          ),
        ),
      );

      // Should format as 01:05:10
      expect(find.text('01:05:10'), findsOneWidget);
    });

    testWidgets('resetTimer works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyTimerCount(
              controller: controller,
              duration: const EasyTime(seconds: 10),
              rankingType: RankingType.descending,
              onTimerStarts: () => timerStartCalls++,
              onTimerEnds: () => timerEndCalls++,
              resetTimer: true,
            ),
          ),
        ),
      );

      // After 10 seconds it should reach zero and reset
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(seconds: 1));
      }

      // After reset it should be back to 00:10 (but not running)
      expect(find.text('00:10'), findsOneWidget);
      expect(timerEndCalls, equals(1));
    });

    testWidgets('Widget disposes timer correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyTimerCount(
              controller: controller,
              duration: const EasyTime(seconds: 10),
              rankingType: RankingType.descending,
              onTimerStarts: () => timerStartCalls++,
              onTimerEnds: () => timerEndCalls++,
            ),
          ),
        ),
      );

      // Now dispose by replacing with an empty container
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(),
          ),
        ),
      );

      // No error should occur (timer should be cancelled)
      expect(true, isTrue); // Just to have an expectation
    });

    testWidgets('Style properties are correctly applied', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EasyTimerCount(
              controller: controller,
              duration: const EasyTime(seconds: 10),
              rankingType: RankingType.descending,
              onTimerStarts: () => timerStartCalls++,
              onTimerEnds: () => timerEndCalls++,
              timerColor: Colors.red,
              timerTextWeight: FontWeight.bold,
              fontSize: 20,
              backgroundColor: Colors.yellow,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style!.color, Colors.red);
      expect(textWidget.style!.fontWeight, FontWeight.bold);
      expect(textWidget.style!.fontSize, 20);
      expect(textWidget.style!.backgroundColor, Colors.yellow);
    });

    testWidgets('FittedBox respects width and height constraints', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: EasyTimerCount(
                controller: controller,
                duration: const EasyTime(seconds: 10),
                rankingType: RankingType.descending,
                onTimerStarts: () => timerStartCalls++,
                onTimerEnds: () => timerEndCalls++,
                width: 100,
                height: 50,
              ),
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 100);
      expect(sizedBox.height, 50);
    });
  });
}