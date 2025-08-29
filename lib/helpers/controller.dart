part of '../easy_timer_count.dart';

/// A controller to manage an [EasyTimerCount] externally.
///
/// Example usage:
/// ```dart
/// final controller = EasyTimerController();
///
/// EasyTimerCount(
///   duration: EasyTime(seconds: 30),
///   controller: controller,
///   onTimerStarts: (context) {},
///   onTimerEnds: (context) {},
/// );
///
/// // Control the timer
/// controller.stop();
/// controller.restart();
/// ```
class EasyTimerController {
  late _EasyTimerCountState _timerState;

  /// Internal method to bind the controller to the timer state.
  void _setState(_EasyTimerCountState state) {
    _timerState = state;
  }

  /// Restarts the timer from the beginning.
  void restart() {
    _timerState._restart();
  }

  /// Stops the timer completely.
  void stop() {
    _timerState._stopTimer();
  }

  /// Resumes the timer after pausing.
  void resume() {
    _timerState._resumeTimer();
  }

  /// Resets the timer without running it.
  void reset() {
    _timerState._resetTimer();
    _timerState._timer.cancel();
  }

  /// Disposes the controller and cancels the timer.
  void dispose() {
    _timerState._timer.cancel();
  }
}