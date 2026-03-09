library customized_timer;

import 'dart:async';
import 'package:easy_timer_count/extensions/null_extension.dart';
import 'package:easy_timer_count/extensions/zero_extension.dart';
import 'package:easy_timer_count/helpers/time.dart';
import 'package:flutter/material.dart';
import 'helpers/ranking.dart';
import 'helpers/separator.dart';
part 'helpers/controller.dart';

/// A customizable timer widget with support for start, stop, reset, resume, and restart.
///
/// Example usage:
/// ```dart
/// EasyTimerCount(
///   duration: EasyTime(minutes: 1),
///   onTimerStarts: (context) => print("Timer started"),
///   onTimerEnds: (context) => print("Timer ended"),
/// )
/// ```
class EasyTimerCount extends StatefulWidget {
  /// Optional controller to manage the timer manually.
  final EasyTimerController? controller;

  /// Type of separator between the displayed numbers.
  final SeparatorType? separatorType;

  /// Whether the timer counts up ([RankingType.ascending]) or down ([RankingType.descending]).
  final RankingType rankingType;

  /// The duration of the timer.
  final EasyTime duration;

  /// Callback triggered when the timer starts.
  final FutureOr<void> Function(BuildContext context) onTimerStarts;

  /// Callback triggered when the timer ends.
  final FutureOr<void> Function(BuildContext context) onTimerEnds;

  /// Callback triggered when the timer restarts (only if [reCountAfterFinishing] is true).
  final FutureOr<void> Function(BuildContext context, int countOfRestart)? onTimerRestart;

  /// Whether the timer should reset after finishing.
  final bool resetTimer;

  /// Whether the timer should automatically restart after finishing.
  final bool reCountAfterFinishing;

  /// Color of the timer text.
  final Color? timerColor;

  /// Font weight of the timer text.
  final FontWeight? timerTextWeight;

  /// Font size of the timer text.
  final double? fontSize;

  /// Word spacing of the timer text.
  final double? wordSpacing;

  /// Letter spacing of the timer text.
  final double? letterSpacing;

  /// Decoration applied to the timer text.
  final TextDecoration? decoration;

  /// Background color of the timer text.
  final Color? backgroundColor;

  /// Decoration style of the timer text.
  final TextDecorationStyle? textDecorationStyle;

  /// Font family of the timer text.
  final String? fontFamily;

  /// Custom builder to render the timer with a different widget instead of [Text].
  final Widget Function(String time)? builder;

  /// Locale for text rendering.
  final Locale? locale;

  /// Overflow behavior for the timer text.
  final TextOverflow? textOverflow;

  /// Default constructor for [EasyTimerCount].
  EasyTimerCount({
    super.key,
    required this.duration,
    required this.onTimerStarts,
    required this.onTimerEnds,
    this.rankingType = RankingType.descending,
    this.separatorType = SeparatorType.colon,
    this.resetTimer = false,
    this.timerColor,
    this.timerTextWeight,
    this.fontSize,
    this.wordSpacing,
    this.letterSpacing,
    this.decoration,
    this.backgroundColor,
    this.textDecorationStyle,
    this.fontFamily,
    this.locale,
    this.textOverflow,
    this.controller,
    this.reCountAfterFinishing = false,
    this.onTimerRestart,
  })  : builder = null,
        assert(duration.seconds.isNotEqualZero || duration.minutes.isNotEqualZero || duration.hours.isNotEqualZero),
        assert(
        (reCountAfterFinishing && (onTimerRestart.isNotNull || onTimerRestart.isNull))
            || (!reCountAfterFinishing && onTimerRestart.isNull)
        );

  /// Builder constructor for [EasyTimerCount] to allow custom rendering.
  EasyTimerCount.builder({
    super.key,
    required this.duration,
    required this.builder,
    required this.onTimerStarts,
    required this.onTimerEnds,
    this.rankingType = RankingType.descending,
    this.separatorType = SeparatorType.colon,
    this.resetTimer = false,
    this.controller,
    this.reCountAfterFinishing = false,
    this.onTimerRestart,
  })  : timerColor = null,
        timerTextWeight = null,
        fontSize = null,
        wordSpacing = null,
        letterSpacing = null,
        decoration = null,
        backgroundColor = null,
        textDecorationStyle = null,
        fontFamily = null,
        locale = null,
        textOverflow = null,
        assert(duration.seconds.isNotEqualZero || duration.minutes.isNotEqualZero || duration.hours.isNotEqualZero),
        assert(
        (reCountAfterFinishing && (onTimerRestart.isNotNull || onTimerRestart.isNull))
            || (!reCountAfterFinishing && onTimerRestart.isNull)
        );

  @override
  State<EasyTimerCount> createState() => _EasyTimerCountState();
}

/// Internal state of [EasyTimerCount].
class _EasyTimerCountState extends State<EasyTimerCount>
    with WidgetsBindingObserver {
  /// Separator used between time units.
  late String separator;

  /// Current number of seconds left or elapsed.
  late int _seconds;

  /// Internal timer instance.
  late Timer _timer;

  /// Number of times the timer has restarted.
  int count = 0;

  /// The wall-clock time when the current timer period started or resumed.
  DateTime? _startTime;

  /// The value of [_seconds] at the moment the timer started or resumed.
  int _secondsAtStart = 0;

  /// Whether the timer is currently running.
  bool _isRunning = false;

  /// Chooses the separator string based on [SeparatorType].
  String get _getSeparator {
    switch (widget.separatorType) {
      case SeparatorType.colon:
        return ':';
      case SeparatorType.dashed:
        return '-';
      default:
        return '';
    }
  }

  /// Converts seconds into a formatted string like `mm:ss` or `hh:mm:ss`.
  String _formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int secs = seconds % 60;

    if (_seconds >= 3600) {
      return '${hours.toString().padLeft(2, '0')}$separator${minutes.toString().padLeft(2, '0')}$separator${secs.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}$separator${secs.toString().padLeft(2, '0')}';
    }
  }

  /// Executes logic depending on [RankingType].
  void _manageTimerBasedRanking({
    required void Function() actionBasedAscendingRanking,
    required void Function() actionBasedDescendingRanking,
  }) {
    switch (widget.rankingType) {
      case RankingType.ascending:
        actionBasedAscendingRanking();
        break;
      case RankingType.descending:
        actionBasedDescendingRanking();
        break;
    }
  }

  /// Initializes the timer value at the start.
  void _manageTimeStarting() {
    _manageTimerBasedRanking(
      actionBasedAscendingRanking: () => setState(() => _seconds = 0),
      actionBasedDescendingRanking: () =>
          setState(() => _seconds = widget.duration.toSeconds),
    );
  }

  /// Updates the timer based on actual wall-clock elapsed time.
  void _manageTimerChanging() {
    if (_startTime == null) return;
    final int elapsed = DateTime.now().difference(_startTime!).inSeconds;
    _manageTimerBasedRanking(
      actionBasedAscendingRanking: () {
        _seconds = (_secondsAtStart + elapsed).clamp(0, widget.duration.toSeconds);
        if (_seconds >= widget.duration.toSeconds) {
          _stopTimer();
          if (widget.resetTimer) _resetTimer();
          if (widget.reCountAfterFinishing) _restart();
        }
      },
      actionBasedDescendingRanking: () {
        _seconds = (_secondsAtStart - elapsed).clamp(0, widget.duration.toSeconds);
        if (_seconds <= 0) {
          _stopTimer();
          if (widget.resetTimer) _resetTimer();
          if (widget.reCountAfterFinishing) _restart();
        }
      },
    );
  }

  /// Starts the timer.
  Future<void> _startTimer() async {
    _manageTimeStarting();
    _startTime = DateTime.now();
    _secondsAtStart = _seconds;
    _isRunning = true;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) => setState(() => _manageTimerChanging()),
    );
    await widget.onTimerStarts(context);
  }

  /// Resumes the timer after pausing.
  void _resumeTimer() {
    _timer.cancel();
    _startTime = DateTime.now();
    _secondsAtStart = _seconds;
    _isRunning = true;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) => setState(() => _manageTimerChanging()),
    );
  }

  /// Stops the timer completely.
  Future<void> _stopTimer() async {
    _isRunning = false;
    _startTime = null;
    _timer.cancel();
    await widget.onTimerEnds(context);
  }

  /// Resets the timer back to initial value.
  void _resetTimer() {
    _startTime = null;
    _manageTimerBasedRanking(
      actionBasedAscendingRanking: () => setState(() => _seconds = 0),
      actionBasedDescendingRanking: () =>
          setState(() => _seconds = widget.duration.toSeconds),
    );
  }

  /// Restarts the timer from the beginning.
  void _restart() {
    count++;
    if (_timer.isActive) {
      _timer.cancel();
    }
    _resetTimer();
    _startTimer();
    widget.onTimerRestart?.call(context, count);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isRunning) {
      // Sync the displayed time to actual elapsed wall-clock time
      setState(() => _manageTimerChanging());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _isRunning = false;
    _startTime = null;
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.controller?._setState(this);
    separator = _getSeparator;
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.isNull ?
    FittedBox(
      child: Text(
        _formatTime(_seconds),
        style: TextStyle(
          fontWeight: widget.timerTextWeight,
          color: widget.timerColor,
          fontSize: widget.fontSize ?? 16,
          wordSpacing: widget.wordSpacing,
          letterSpacing: widget.letterSpacing,
          decoration: widget.decoration,
          backgroundColor: widget.backgroundColor,
          decorationStyle: widget.textDecorationStyle,
          fontFamily: widget.fontFamily,
          locale: widget.locale ?? const Locale('en'),
          overflow: widget.textOverflow ?? TextOverflow.ellipsis,
        ),
      ),
    ) : widget.builder!(_formatTime(_seconds));
  }
}


