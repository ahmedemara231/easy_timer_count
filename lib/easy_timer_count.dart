library customized_timer;
import 'dart:async';
import 'package:easy_timer_count/extensions/null_extension.dart';
import 'package:flutter/material.dart';

class EasyTime{
  final int hours;
  final int minutes;
  final int seconds;

  const EasyTime({this.hours = 0, this.minutes = 0, this.seconds = 0});

  int get toSeconds => hours * 3600 + minutes * 60 + seconds;
}

enum RankingType{ascending, descending}
enum SeparatorType{colon, dashed, none}

class EasyTimerCount extends StatefulWidget {
  final EasyTimerController? controller;
  final SeparatorType? separatorType;
  final RankingType rankingType;
  final EasyTime duration;
  final FutureOr<void> Function(BuildContext context) onTimerStarts;
  final FutureOr<void> Function(BuildContext context) onTimerEnds;
  final FutureOr<void> Function(BuildContext context, int countOfRestart)? onTimerRestart;
  final bool resetTimer;
  final bool reCountAfterFinishing;
  final Color? timerColor;
  final FontWeight? timerTextWeight;
  final double? fontSize;
  final double? wordSpacing;
  final double? letterSpacing;
  final TextDecoration? decoration;
  final Color? backgroundColor;
  final TextDecorationStyle? textDecorationStyle;
  final String? fontFamily;
  final Widget Function(String time)? builder;
  final Locale? locale;
  final TextOverflow? textOverflow;

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
    this.onTimerRestart
  }) : builder = null,
  assert(reCountAfterFinishing && (reCountAfterFinishing.isNotNull || reCountAfterFinishing.isNull) ||
      (!reCountAfterFinishing && reCountAfterFinishing.isNull)
  );

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
    this.onTimerRestart
  }) :
        timerColor = null,
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
        assert(reCountAfterFinishing && (reCountAfterFinishing.isNotNull || reCountAfterFinishing.isNull) ||
            (!reCountAfterFinishing && reCountAfterFinishing.isNull)
        );


  @override
  State<EasyTimerCount> createState() => _EasyTimerCountState();
}

class _EasyTimerCountState extends State<EasyTimerCount> {

  // void _setState(Function function) {
  //   function();
  // }

  late String separator;
  String get _getSeparator{
    switch(widget.separatorType){
      case SeparatorType.colon:
        return ':';
      case SeparatorType.dashed:
        return '-';
      default:
        return '';
    }
  }

  late int _seconds;

  String _formatTime(int seconds) {
    // final int days = seconds ~/ 86400;
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int secs = seconds % 60;

    // if (_seconds >= 86400) {
    //   return '${days.toString().padLeft(2, '0')}:${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    // }

    if(_seconds >= 3600){
      return '${hours.toString().padLeft(2, '0')}$separator${minutes.toString().padLeft(2, '0')}$separator${secs.toString().padLeft(2, '0')}';
    }else{
      return '${minutes.toString().padLeft(2, '0')}$separator${secs.toString().padLeft(2, '0')}';
    }
  }

  late Timer _timer;

  void _manageTimerBasedRanking({
    required void Function() actionBasedAscendingRanking,
    required void Function() actionBasedDescendingRanking,
}){
    switch(widget.rankingType){
      case RankingType.ascending:
        actionBasedAscendingRanking();
        break;

      case RankingType.descending:
        actionBasedDescendingRanking();
        break;
    }
  }

  void _manageTimeStarting(){
    _manageTimerBasedRanking(
        actionBasedAscendingRanking: () => setState(() => _seconds = 0),
        actionBasedDescendingRanking: () => setState(() => _seconds = widget.duration.toSeconds)
    );
  }

  void _manageTimerChanging(){
    _manageTimerBasedRanking(
        actionBasedAscendingRanking: () {
          _seconds++;
          if (_seconds == widget.duration.toSeconds) {
            _stopTimer();
            if(widget.resetTimer){
              // TODO: delay for 1 second
              _resetTimer();
            }
            if(widget.reCountAfterFinishing){
              _restart();
            }
          }
        },
        actionBasedDescendingRanking: () {
          _seconds--;
          if (_seconds == 0) {
            _stopTimer();
            if(widget.resetTimer){
              // TODO: delay for 1 second
              _resetTimer();
            }
            if(widget.reCountAfterFinishing){
              _restart();
            }
          }
        }
     );
  }

  Future<void> _startTimer() async{
    _manageTimeStarting();
    _timer = Timer.periodic(
        const Duration(seconds: 1),
            (timer) => setState(() => _manageTimerChanging())
    );
    await widget.onTimerStarts(context);
  }

  void _resumeTimer() {
    _timer.cancel();
    _timer = Timer.periodic(
        const Duration(seconds: 1),
            (timer) => setState(() => _manageTimerChanging())
    );
  }

  Future<void> _stopTimer() async{
    _timer.cancel();
    await widget.onTimerEnds(context);
  }

  void _resetTimer() {
    _manageTimerBasedRanking(
        actionBasedAscendingRanking: () => setState(() => _seconds = 0),
        actionBasedDescendingRanking: () => setState(() => _seconds = widget.duration.toSeconds)
    );
  }

  int count = 0;

  void _restart() {
    count++;
    if(_timer.isActive){
      _timer.cancel();
    }
    _resetTimer();
    _startTimer();
    widget.onTimerRestart?.call(context, count);
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  @override
  void initState() {
    widget.controller?._setState(this);
    separator = _getSeparator;
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder == null? FittedBox(
      child: Text(
        _formatTime(_seconds),
        style: TextStyle(
          fontWeight: widget.timerTextWeight,
          color: widget.timerColor,
          fontSize: widget.fontSize?? 16,
          wordSpacing: widget.wordSpacing,
          letterSpacing: widget.letterSpacing,
          decoration: widget.decoration,
          backgroundColor: widget.backgroundColor,
          decorationStyle: widget.textDecorationStyle,
          fontFamily: widget.fontFamily,
          locale: widget.locale?? const Locale('en'),
          overflow: widget.textOverflow?? TextOverflow.ellipsis,
        ),
      ),
    ) : widget.builder!(_formatTime(_seconds));
  }
}

class EasyTimerController {
  _EasyTimerCountState? _timerState;

  void _setState(_EasyTimerCountState state) {
    _timerState = state;
  }

  void restart() {
    if (_timerState != null) {
      _timerState!._restart();
    }
  }

  void stop() {
    if (_timerState != null) {
      _timerState!._stopTimer();
    }
  }

  void resume() {
    if (_timerState != null) {
      _timerState!._resumeTimer();
    }
  }

  void reset() {
    if (_timerState != null) {
      _timerState!._resetTimer();
      _timerState!._timer.cancel();
    }
  }

  void dispose() {
    if (_timerState != null) {
      _timerState!._timer.cancel();
      _timerState = null;
    }
  }
// bool get isPaused => _timerState?._isPaused ?? true;
}
