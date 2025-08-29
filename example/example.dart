import 'package:easy_timer_count/helpers/ranking.dart';
import 'package:easy_timer_count/helpers/time.dart';
import 'package:flutter/material.dart';
import 'package:easy_timer_count/easy_timer_count.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TimerExampleScreen(),
    );
  }
}

class TimerExampleScreen extends StatefulWidget {
  const TimerExampleScreen({super.key});

  @override
  State<TimerExampleScreen> createState() => _TimerExampleScreenState();
}

class _TimerExampleScreenState extends State<TimerExampleScreen> {
  final EasyTimerController _controller = EasyTimerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Easy Timer Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EasyTimerCount.builder(
              duration: const EasyTime(seconds: 15),
              rankingType: RankingType.descending,
              onTimerStarts: (context) async => debugPrint("Started"),
              onTimerEnds: (context) async => debugPrint("Ended"),
              builder: (time) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    time,
                    style: const TextStyle(color: Colors.white, fontSize: 32),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: _controller.restart,
                  child: const Text("Restart"),
                ),
                ElevatedButton(
                  onPressed: _controller.stop,
                  child: const Text("Stop"),
                ),
                ElevatedButton(
                  onPressed: _controller.resume,
                  child: const Text("Resume"),
                ),
                ElevatedButton(
                  onPressed: _controller.reset,
                  child: const Text("Reset"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
