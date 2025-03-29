# EasyTimerCount

A flexible and customizable timer widget for Flutter applications that supports both countdown and count-up timers with various styling options.

[![Pub Version](https://img.shields.io/pub/v/easy_timer_count.svg)](https://pub.dev/packages/easy_timer_count)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- 🕒 Support for both countdown and count-up timers
- 🔁 Auto-restart functionality for repeating timers
- 🎨 Highly customizable appearance
- 🔧 Simple controller for start, stop, resume, and reset operations
- 📐 Custom time formatting with different separator options
- 🧩 Custom builder for complete UI flexibility

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  easy_timer_count: ^1.0.0
```

Then run:

```
$ flutter pub get
```

## Usage

### Basic Usage

```dart
// Create a controller
final timerController = EasyTimerController();

// Create a simple countdown timer
EasyTimerCount(
  controller: timerController,
  duration: EasyTime(minutes: 5), // 5 minute timer
  rankingType: RankingType.descending, // Counts down
  onTimerStarts: () => print('Timer started'),
  onTimerEnds: () => print('Timer ended'),
)
```

### Custom Styling

```dart
EasyTimerCount(
  controller: timerController,
  duration: EasyTime(minutes: 2, seconds: 30),
  rankingType: RankingType.descending,
  onTimerStarts: () => print('Timer started'),
  onTimerEnds: () => print('Timer ended'),
  timerColor: Colors.blue,
  timerTextWeight: FontWeight.bold,
  fontSize: 24,
  backgroundColor: Colors.grey[200],
  separatorType: SeparatorType.dashed, // Use dashes as separators
)
```

### Custom Builder

```dart
EasyTimerCount.custom(
  controller: timerController,
  duration: EasyTime(minutes: 1),
  rankingType: RankingType.descending,
  onTimerStarts: () => print('Timer started'),
  onTimerEnds: () => print('Timer ended'),
  builder: (time) => Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.amber,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      'Time left: $time',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
)
```

### Repeating Timer

```dart
EasyTimerCount.repeat(
  controller: timerController,
  duration: EasyTime(seconds: 30),
  rankingType: RankingType.descending,
  onTimerStarts: () => print('Timer started'),
  onTimerEnds: () => print('Timer completed a cycle'),
  onTimerRestart: (count) => print('Restarted $count times'),
)
```

### Controller Usage

```dart
// Create a button to control the timer
ElevatedButton(
  onPressed: () => timerController.stop(),
  child: Text('Pause Timer'),
),

ElevatedButton(
  onPressed: () => timerController.resume(),
  child: Text('Resume Timer'),
),

ElevatedButton(
  onPressed: () => timerController.restart(),
  child: Text('Restart Timer'),
),

ElevatedButton(
  onPressed: () => timerController.reset(),
  child: Text('Reset Timer'),
),
```

## Creating Time Durations

Use the `EasyTime` class to specify timer durations:

```dart
// Create a 1 hour timer
EasyTime(hours: 1)

// Create a 2 minutes and 30 seconds timer
EasyTime(minutes: 2, seconds: 30)

// Create a 3 hour, 45 minute, 10 second timer
EasyTime(hours: 3, minutes: 45, seconds: 10)
```

## Available Properties

| Property              | Type                         | Description                                          |
|-----------------------|------------------------------|------------------------------------------------------|
| controller            | EasyTimerController          | Controller for managing timer state                  |
| duration              | EasyTime                     | Duration of the timer                                |
| rankingType           | RankingType                  | Whether timer counts up (ascending) or down (descending) |
| onTimerStarts         | Function()                   | Called when timer starts                             |
| onTimerEnds           | Function()                   | Called when timer ends                               |
| onTimerRestart        | Function(int)?               | Called when timer restarts with restart count        |
| separatorType         | SeparatorType                | Type of separator in time display (:, -, or none)    |
| resetTimer            | bool                         | Whether to reset after completion                    |
| reCountAfterFinishing | bool                         | Whether to restart after completion                  |
| timerColor            | Color?                       | Text color of the timer                              |
| timerTextWeight       | FontWeight?                  | Font weight of the timer text                        |
| fontSize              | double?                      | Font size of the timer text                          |
| wordSpacing           | double?                      | Word spacing of the timer text                       |
| letterSpacing         | double?                      | Letter spacing of the timer text                     |
| decoration            | TextDecoration?              | Text decoration of the timer text                    |
| backgroundColor       | Color?                       | Background color of the timer text                   |
| textDecorationStyle   | TextDecorationStyle?         | Style of text decoration                             |
| fontFamily            | String?                      | Font family of the timer text                        |
| builder               | Widget Function(String)?     | Custom builder for timer UI                          |
| locale                | Locale?                      | Locale for the timer text                            |
| textOverflow          | TextOverflow?                | How to handle text overflow                          |
| height                | double?                      | Height of the timer widget                           |
| width                 | double?                      | Width of the timer widget                            |

## Constructors

| Constructor           | Description                                          |
|-----------------------|------------------------------------------------------|
| EasyTimerCount        | Basic timer with styling options                     |
| EasyTimerCount.custom | Timer with custom builder for complete UI flexibility |
| EasyTimerCount.repeat | Auto-repeating timer                                 |
| EasyTimerCount.repeatCustom | Auto-repeating timer with custom builder        |

## Controller Methods

| Method                | Description                                          |
|-----------------------|------------------------------------------------------|
| stop()                | Pauses the timer                                     |
| resume()              | Resumes a paused timer                               |
| restart()             | Restarts the timer with the original duration        |
| reset()               | Resets the timer to its initial state and stops it   |

## Enums

### RankingType
- `RankingType.ascending`: Timer counts up from zero
- `RankingType.descending`: Timer counts down from duration to zero

### SeparatorType
- `SeparatorType.colon`: Use colons as separators (01:30:45)
- `SeparatorType.dashed`: Use dashes as separators (01-30-45)
- `SeparatorType.none`: No separators (013045)

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
      title: 'Easy Timer Count Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final timerController = EasyTimerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Timer Count Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EasyTimerCount(
              controller: timerController,
              duration: EasyTime(minutes: 2, seconds: 30),
              rankingType: RankingType.descending,
              onTimerStarts: () => print('Timer started'),
              onTimerEnds: () => print('Timer ended'),
              timerColor: Colors.blue,
              fontSize: 32,
              timerTextWeight: FontWeight.bold,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => timerController.stop(),
                  child: const Text('Pause'),
                ),
                ElevatedButton(
                  onPressed: () => timerController.resume(),
                  child: const Text('Resume'),
                ),
                ElevatedButton(
                  onPressed: () => timerController.restart(),
                  child: const Text('Restart'),
                ),
                ElevatedButton(
                  onPressed: () => timerController.reset(),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.
