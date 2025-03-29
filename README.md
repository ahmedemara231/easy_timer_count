# EasyTimerCount

A flexible and customizable Flutter timer widget that supports both countdown and count-up functionality with various styling options.

[![Pub Version](https://img.shields.io/pub/v/easy_timer_count.svg)](https://pub.dev/packages/easy_timer_count)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- Count up (ascending) or count down (descending) timers
- Customizable appearance with various styling options
- Support for timer completion callbacks
- Ability to restart timers automatically
- Custom builder for complete control over timer appearance
- Timer reset functionality

## Installation

Add `easy_timer_count` to your `pubspec.yaml` file:

```yaml
dependencies:
  easy_timer_count: ^1.0.0
```

Then run:

```
flutter pub get
```

## Usage

Import the package:

```dart
import 'package:easy_timer_count/easy_timer_count.dart';
```

### Basic Timer

```dart
EasyTimerCount(
  duration: Duration(seconds: 30),
  rankingType: RankingType.descending,
  onTimerStarts: () => print('Timer started'),
  onTimerEnds: () => print('Timer ended'),
)
```

### Styling the Timer

```dart
EasyTimerCount(
  duration: Duration(minutes: 5),
  rankingType: RankingType.descending,
  onTimerStarts: () => print('Timer started'),
  onTimerEnds: () => print('Timer ended'),
  timerColor: Colors.red,
  timerTextWeight: FontWeight.bold,
  fontSize: 24,
  backgroundColor: Colors.grey[200],
  fontFamily: 'Roboto',
)
```

### Auto-Repeating Timer

```dart
EasyTimerCount.repeat(
  duration: Duration(seconds: 10),
  rankingType: RankingType.ascending,
  onTimerStarts: () => print('Timer started'),
  onTimerEnds: () => print('Timer ended'),
  onTimerRestart: (restartCount) => print('Timer restarted $restartCount times'),
)
```

### Custom Builder

```dart
EasyTimerCount.custom(
  duration: Duration(minutes: 1),
  rankingType: RankingType.descending,
  onTimerStarts: () => print('Timer started'),
  onTimerEnds: () => print('Timer ended'),
  builder: (time) => Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      time,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
)
```

## Available Constructors

### Standard Timer
`EasyTimerCount` - Basic timer with styling options

### Custom Display Timer
`EasyTimerCount.custom` - Timer with a custom builder for complete UI control

### Auto-Repeating Timer
`EasyTimerCount.repeat` - Timer that restarts automatically when finished

### Auto-Repeating Custom Timer
`EasyTimerCount.repeatCustom` - Auto-repeating timer with custom UI

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `duration` | `Duration` | Duration of the timer |
| `rankingType` | `RankingType` | `ascending` (count up) or `descending` (count down) |
| `onTimerStarts` | `Function()` | Callback when timer starts |
| `onTimerEnds` | `Function()` | Callback when timer ends |
| `onTimerRestart` | `Function(int)` | Callback when timer restarts (with restart count) |
| `resetTimer` | `bool` | Whether to reset the timer on completion |
| `reCountAfterFinishing` | `bool` | Whether to restart the timer after completion |
| `timerColor` | `Color?` | Color of the timer text |
| `timerTextWeight` | `FontWeight?` | Font weight of the timer text |
| `fontSize` | `double?` | Font size of the timer text |
| `wordSpacing` | `double?` | Word spacing of the timer text |
| `letterSpacing` | `double?` | Letter spacing of the timer text |
| `decoration` | `TextDecoration?` | Text decoration of the timer text |
| `backgroundColor` | `Color?` | Background color of the timer text |
| `textDecorationStyle` | `TextDecorationStyle?` | Style of the text decoration |
| `fontFamily` | `String?` | Font family of the timer text |
| `builder` | `Widget Function(String)?` | Custom builder for the timer display |
| `locale` | `Locale?` | Locale for the timer text |
| `textOverflow` | `TextOverflow?` | How to handle text overflow |
| `height` | `double?` | Height of the timer widget |
| `width` | `double?` | Width of the timer widget |

## Time Format

The timer automatically formats the time display based on the duration:

- Less than 1 hour: `MM:SS` (minutes:seconds)
- 1 hour or more: `HH:MM:SS` (hours:minutes:seconds)

## License

This project is licensed under the MIT License - see the LICENSE file for details.
