# EasyTimerCount

![Pub Version](https://img.shields.io/badge/pub-v1.0.0-blue)
![Flutter Platform](https://img.shields.io/badge/platform-flutter-yellow)
![License](https://img.shields.io/badge/license-MIT-green)

A flexible and customizable timer widget for Flutter applications. `EasyTimerCount` provides a straightforward way to implement countdown or count-up timers with extensive styling options and control capabilities.

## Features

- 🕒 Simple API for creating countdown or count-up timers
- 🔄 Ability to restart, pause, resume, and reset timers
- 🎨 Extensive styling and formatting options
- 🛠️ Custom builder support for completely custom UIs
- 🔄 Auto-restart functionality
- 🎮 External controller for timer management
- ⏲️ Multiple time display formats

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  easy_timer_count: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Timer

Create a simple countdown timer:

```dart
EasyTimerCount(
  duration: const EasyTime(minutes: 1, seconds: 30),
  rankingType: RankingType.descending,
  onTimerStarts: () => print('Timer started'),
  onTimerEnds: () => print('Timer ended'),
)
```

### Timer with Controller

Use a controller to manage the timer externally:

```dart
final controller = EasyTimerController();

// In your widget build method:
EasyTimerCount(
  duration: const EasyTime(minutes: 5),
  rankingType: RankingType.descending,
  onTimerStarts: () => print('Timer started'),
  onTimerEnds: () => print('Timer ended'),
  controller: controller,
)

// Control the timer from anywhere:
controller.stop();    // Pause the timer
controller.resume();  // Resume the timer
controller.reset();   // Reset the timer
controller.restart(); // Restart the timer
```

### Repeating Timer

Create a timer that automatically restarts when finished:

```dart
EasyTimerCount.repeat(
  duration: const EasyTime(seconds: 30),
  rankingType: RankingType.descending,
  onTimerStarts: () => print('Timer started'),
  onTimerEnds: () => print('Timer ended'),
  onTimerRestart: (count) => print('Timer restarted $count times'),
)
```

### Custom Timer UI

Completely customize the timer's appearance:

```dart
EasyTimerCount.builder(
  duration: const EasyTime(minutes: 1),
  rankingType: RankingType.descending,
  onTimerStarts: () => print('Timer started'),
  onTimerEnds: () => print('Timer ended'),
  builder: (String time) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      'Remaining: $time',
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
)
```

## API Reference

### EasyTime

Represents a duration with hours, minutes, and seconds.

```dart
const EasyTime({
  int hours = 0,
  int minutes = 0,
  int seconds = 0,
});
```

### EasyTimerCount

Main timer widget with various constructors:

#### Basic Constructor

```dart
EasyTimerCount({
  required EasyTime duration,
  required RankingType rankingType,
  required Function() onTimerStarts,
  required Function() onTimerEnds,
  SeparatorType? separatorType = SeparatorType.colon,
  bool resetTimer = false,
  // Style properties...
  EasyTimerController? controller,
  double? height,
  double? width,
})
```

#### Builder Constructor

```dart
EasyTimerCount.builder({
  required EasyTime duration,
  required Widget Function(String time) builder,
  required RankingType rankingType,
  required Function() onTimerStarts,
  required Function() onTimerEnds,
  SeparatorType? separatorType = SeparatorType.colon,
  bool resetTimer = false,
  EasyTimerController? controller,
  double? width,
  double? height,
})
```

#### Repeat Constructor

```dart
EasyTimerCount.repeat({
  required EasyTime duration,
  required RankingType rankingType,
  required Function() onTimerStarts,
  required Function() onTimerEnds,
  required Function(int countOfRestart) onTimerRestart,
  // Style properties...
  SeparatorType? separatorType = SeparatorType.colon,
  EasyTimerController? controller,
  double? height,
  double? width,
})
```

#### RepeatBuilder Constructor

```dart
EasyTimerCount.repeatBuilder({
  required EasyTime duration,
  required Widget Function(String time) builder,
  required RankingType rankingType,
  required Function() onTimerStarts,
  required Function() onTimerEnds,
  required Function(int countOfRestart) onTimerRestart,
  SeparatorType? separatorType = SeparatorType.colon,
  EasyTimerController? controller,
  double? width,
  double? height,
})
```

### EasyTimerController

Controller for managing timer externally:

```dart
final controller = EasyTimerController();

// Methods:
controller.stop();    // Stop the timer
controller.resume();  // Resume a stopped timer
controller.reset();   // Reset the timer to initial state
controller.restart(); // Restart the timer from the beginning
```

### Enums

```dart
// Determines if the timer counts up or down
enum RankingType { ascending, descending }

// Sets the separator style in the time display
enum SeparatorType { colon, dashed, none }
```

## Example

```dart
import 'package:flutter/material.dart';
import 'package:easy_timer_count/easy_timer_count.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('EasyTimerCount Demo')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Basic countdown timer - 3 minutes
              EasyTimerCount(
                duration: const EasyTime(minutes: 3),
                rankingType: RankingType.descending,
                onTimerStarts: () => print('Timer started'),
                onTimerEnds: () => print('Timer finished'),
                timerColor: Colors.blue,
                fontSize: 24,
                timerTextWeight: FontWeight.bold,
              ),
              
              const SizedBox(height: 40),
              
              // Count-up timer with custom styling - up to 1 minute
              EasyTimerCount(
                duration: const EasyTime(minutes: 1),
                rankingType: RankingType.ascending,
                onTimerStarts: () => print('Timer started'),
                onTimerEnds: () => print('Timer reached 1 minute'),
                timerColor: Colors.green,
                fontSize: 28,
                timerTextWeight: FontWeight.w500,
                separatorType: SeparatorType.dashed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Notes

- The timer uses Flutter's `Timer` class, which means it will pause when the app is in the background
- For accurate timing across app states, consider a more robust timing solution
- Time display is adaptive - it will display hours only when needed

## License

This project is licensed under the MIT License - see the LICENSE file for details.
