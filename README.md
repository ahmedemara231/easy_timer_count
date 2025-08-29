# Easy Timer Count

A powerful and customizable Flutter package for creating countdown and countup timers with rich styling options and flexible controls.

## Features

- ✅ **Countdown Timer**: Count down from a specified duration
- ✅ **Countup Timer**: Count up to a specified duration  
- ✅ **Flexible Time Format**: Support for hours, minutes, and seconds
- ✅ **Custom Separators**: Choose between colon (:), dash (-), or no separator
- ✅ **Timer Controller**: Programmatically control timer (start, stop, pause, resume, reset, restart)
- ✅ **Auto Reset**: Automatically reset timer when it finishes
- ✅ **Auto Restart**: Continuously restart timer after completion
- ✅ **Custom Builder**: Build your own timer UI with custom widgets
- ✅ **Rich Text Styling**: Full control over timer text appearance
- ✅ **Callback Events**: Handle timer start, end, and restart events
- ✅ **Easy Integration**: Simple and intuitive API

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  easy_timer_count: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Countdown Timer

```dart
import 'package:easy_timer_count/easy_timer_count.dart';

EasyTimerCount(
  duration: EasyTime(minutes: 5, seconds: 30),
  onTimerStarts: (context) {
    print('Timer started!');
  },
  onTimerEnds: (context) {
    print('Timer finished!');
  },
)
```

### Basic Countup Timer

```dart
EasyTimerCount(
  duration: EasyTime(minutes: 10),
  rankingType: RankingType.ascending,
  onTimerStarts: (context) {
    print('Counting up started!');
  },
  onTimerEnds: (context) {
    print('Target reached!');
  },
)
```

### Timer with Controller

```dart
class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final EasyTimerController controller = EasyTimerController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EasyTimerCount(
          controller: controller,
          duration: EasyTime(minutes: 3),
          onTimerStarts: (context) => print('Started'),
          onTimerEnds: (context) => print('Ended'),
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => controller.stop(),
              child: Text('Pause'),
            ),
            ElevatedButton(
              onPressed: () => controller.resume(),
              child: Text('Resume'),
            ),
            ElevatedButton(
              onPressed: () => controller.reset(),
              child: Text('Reset'),
            ),
            ElevatedButton(
              onPressed: () => controller.restart(),
              child: Text('Restart'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
```

### Custom Styling

```dart
EasyTimerCount(
  duration: EasyTime(hours: 1, minutes: 30),
  separatorType: SeparatorType.dashed,
  timerColor: Colors.red,
  fontSize: 24,
  timerTextWeight: FontWeight.bold,
  letterSpacing: 2.0,
  decoration: TextDecoration.underline,
  fontFamily: 'Roboto',
  onTimerStarts: (context) => print('Started'),
  onTimerEnds: (context) => print('Ended'),
)
```

### Custom Builder

```dart
EasyTimerCount.builder(
  duration: EasyTime(minutes: 5),
  builder: (timeString) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Text(
        timeString,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  },
  onTimerStarts: (context) => print('Started'),
  onTimerEnds: (context) => print('Ended'),
)
```

### Auto-Restart Timer

```dart
EasyTimerCount(
  duration: EasyTime(seconds: 30),
  reCountAfterFinishing: true,
  onTimerStarts: (context) => print('Timer started'),
  onTimerEnds: (context) => print('Timer ended'),
  onTimerRestart: (context, restartCount) {
    print('Timer restarted $restartCount times');
  },
)
```

## Parameters

### EasyTimerCount Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `duration` | `EasyTime` | **required** | Timer duration (hours, minutes, seconds) |
| `onTimerStarts` | `Function(BuildContext)` | **required** | Callback when timer starts |
| `onTimerEnds` | `Function(BuildContext)` | **required** | Callback when timer ends |
| `rankingType` | `RankingType` | `descending` | Timer direction (countdown/countup) |
| `separatorType` | `SeparatorType` | `colon` | Separator between time units |
| `controller` | `EasyTimerController?` | `null` | Timer controller for programmatic control |
| `resetTimer` | `bool` | `false` | Auto reset timer when finished |
| `reCountAfterFinishing` | `bool` | `false` | Auto restart timer continuously |
| `onTimerRestart` | `Function(BuildContext, int)?` | `null` | Callback on timer restart |
| `timerColor` | `Color?` | `null` | Timer text color |
| `fontSize` | `double?` | `16` | Timer text font size |
| `timerTextWeight` | `FontWeight?` | `null` | Timer text font weight |
| `letterSpacing` | `double?` | `null` | Letter spacing in timer text |
| `wordSpacing` | `double?` | `null` | Word spacing in timer text |
| `decoration` | `TextDecoration?` | `null` | Text decoration (underline, etc.) |
| `fontFamily` | `String?` | `null` | Custom font family |
| `builder` | `Widget Function(String)?` | `null` | Custom builder for timer UI |

### EasyTime Class

```dart
EasyTime(
  hours: 1,    // Optional: hours (default: 0)
  minutes: 30, // Optional: minutes (default: 0) 
  seconds: 45  // Optional: seconds (default: 0)
)
```

### RankingType Enum

- `RankingType.descending` - Countdown timer (default)
- `RankingType.ascending` - Countup timer

### SeparatorType Enum

- `SeparatorType.colon` - Uses `:` separator (default)
- `SeparatorType.dashed` - Uses `-` separator  
- `SeparatorType.none` - No separator

### EasyTimerController Methods

| Method | Description |
|--------|-------------|
| `restart()` | Restart the timer from beginning |
| `stop()` | Stop/pause the timer |
| `resume()` | Resume the paused timer |
| `reset()` | Reset timer to initial state |
| `dispose()` | Clean up resources |

## Examples

### Workout Timer

```dart
class WorkoutTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EasyTimerCount(
      duration: EasyTime(minutes: 20),
      rankingType: RankingType.descending,
      separatorType: SeparatorType.colon,
      timerColor: Colors.red,
      fontSize: 32,
      timerTextWeight: FontWeight.bold,
      onTimerStarts: (context) {
        // Play start sound
        print('Workout started!');
      },
      onTimerEnds: (context) {
        // Play finish sound
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Workout Complete!'),
            content: Text('Great job! You completed your 20-minute workout.'),
          ),
        );
      },
    );
  }
}
```

### Pomodoro Timer

```dart
class PomodoroTimer extends StatefulWidget {
  @override
  _PomodoroTimerState createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  bool isWorkTime = true;
  
  @override
  Widget build(BuildContext context) {
    return EasyTimerCount(
      key: ValueKey(isWorkTime), // Rebuild when switching modes
      duration: EasyTime(minutes: isWorkTime ? 25 : 5),
      timerColor: isWorkTime ? Colors.red : Colors.green,
      fontSize: 48,
      timerTextWeight: FontWeight.bold,
      onTimerStarts: (context) {
        print('${isWorkTime ? 'Work' : 'Break'} time started');
      },
      onTimerEnds: (context) {
        setState(() {
          isWorkTime = !isWorkTime; // Switch between work and break
        });
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Time\'s up!'),
            content: Text('Time for a ${isWorkTime ? 'work session' : 'break'}'),
          ),
        );
      },
    );
  }
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you like this package, please give it a ⭐ on [GitHub](https://github.com/your-repo/easy_timer_count) and 👍 on [pub.dev](https://pub.dev/packages/easy_timer_count)!

For issues and feature requests, please visit our [GitHub Issues](https://github.com/your-repo/easy_timer_count/issues) page.
