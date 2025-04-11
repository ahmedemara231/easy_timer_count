library customized_timer;
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  final FutureOr<void> Function() onTimerStarts;
  final FutureOr<void> Function() onTimerEnds;
  final FutureOr<void> Function(int countOfRestart)? onTimerRestart;
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
  final double? height;
  final double? width;

  const EasyTimerCount({
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
    this.height,
    this.width,
  }) : builder = null, reCountAfterFinishing = false, onTimerRestart = null;

  const EasyTimerCount.builder({
    super.key,
    required this.duration,
    required this.builder,
    required this.onTimerStarts,
    required this.onTimerEnds,
    this.rankingType = RankingType.descending,
    this.separatorType = SeparatorType.colon,
    this.resetTimer = false,
    this.controller,
    this.width,
    this.height
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
        reCountAfterFinishing = false,
        textOverflow = null,
        onTimerRestart = null;

  const EasyTimerCount.repeat({
    super.key,
    required this.duration,
    required this.onTimerStarts,
    required this.onTimerEnds,
    required this.onTimerRestart,
    this.rankingType = RankingType.descending,
    this.separatorType = SeparatorType.colon,
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
    this.height,
    this.width,
  }) :
        reCountAfterFinishing = true,
        builder = null,
        resetTimer = false;


  const EasyTimerCount.repeatBuilder({
    super.key,
    required this.duration,
    required this.builder,
    required this.onTimerStarts,
    required this.onTimerEnds,
    required this.onTimerRestart,
    this.rankingType = RankingType.descending,
    this.separatorType = SeparatorType.colon,
    this.controller,
    this.width,
    this.height
  }) :
        reCountAfterFinishing = true,
        timerColor = null,
        timerTextWeight = null,
        resetTimer = false,
        fontSize = null,
        wordSpacing = null,
        letterSpacing = null,
        decoration = null,
        backgroundColor = null,
        textDecorationStyle = null,
        fontFamily = null,
        locale = null,
        textOverflow = null;

  @override
  State<EasyTimerCount> createState() => _EasyTimerCountState();
}

class _EasyTimerCountState extends State<EasyTimerCount> {

  void _setState(Function function) {
    function();
    setState(() => widget.controller?._setState(this));
  }

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

  void manageTimeStarting(){
    switch(widget.rankingType){
      case RankingType.ascending:
        _setState(() => _seconds = 0);
        break;
      case RankingType.descending:
        _setState(() => _seconds = widget.duration.toSeconds);
        break;
    }
  }

  void manageTimerChanging(){
    switch(widget.rankingType){
      case RankingType.ascending:
        _seconds++;
        log(_seconds.toString());
        if (_seconds == widget.duration.toSeconds) {
          stopTimer();
          if(widget.resetTimer){
            // TODO: delay for 1 second
            resetTimer();
          }
          if(widget.reCountAfterFinishing){
            restart();
          }
        }
      case RankingType.descending:
        _seconds--;
        if (_seconds == 0) {
          stopTimer();
          if(widget.resetTimer){
            // TODO: delay for 1 second
            resetTimer();
          }
          if(widget.reCountAfterFinishing){
            restart();
          }
        }
    }
  }

  void startTimer() {
    widget.onTimerStarts();
    manageTimeStarting();
    _timer = Timer.periodic(
        const Duration(seconds: 1),
            (timer) => _setState(() => manageTimerChanging())
    );
  }

  void resumeTimer() {
    _timer.cancel();
    _timer = Timer.periodic(
        const Duration(seconds: 1),
            (timer) => _setState(() => manageTimerChanging())
    );
  }

  void stopTimer() {
    widget.onTimerEnds();
    _timer.cancel();
  }

  void resetTimer() {
    if(widget.rankingType == RankingType.ascending){
      _setState(() => _seconds = 0);
    }else{
      _setState(() => _seconds = widget.duration.toSeconds);
    }
  }

  int count = 0;

  void restart() {
    count++;
    if(_timer.isActive){
      _timer.cancel();
    }
    resetTimer();
    startTimer();
    if(widget.onTimerRestart != null){
      widget.onTimerRestart!(count);
    }
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  void initState() {
    separator = _getSeparator;
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: FittedBox(
          child: widget.builder == null? Text(
            _formatTime(_seconds),
            style: TextStyle(
              fontWeight: widget.timerTextWeight,
              color: widget.timerColor,
              fontSize: widget.fontSize?? 16.sp,
              wordSpacing: widget.wordSpacing,
              letterSpacing: widget.letterSpacing,
              decoration: widget.decoration,
              backgroundColor: widget.backgroundColor,
              decorationStyle: widget.textDecorationStyle,
              fontFamily: widget.fontFamily,
              locale: widget.locale?? const Locale('en'),
              overflow: widget.textOverflow?? TextOverflow.ellipsis,
            ),
          ) : widget.builder!(_formatTime(_seconds))
      ),
    );
  }
}

class EasyTimerController {
  _EasyTimerCountState? _timerState;

  void _setState(_EasyTimerCountState state) {
    _timerState = state;
  }

  void restart() {
    if (_timerState != null) {
      _timerState!.restart();
    }
  }

  void stop() {
    if (_timerState != null) {
      _timerState!.stopTimer();
    }
  }

  void resume() {
    if (_timerState != null) {
      _timerState!.resumeTimer();
    }
  }

  void reset() {
    if (_timerState != null) {
      _timerState!.resetTimer();
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
