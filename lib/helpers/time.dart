/// A utility class that defines a time duration in hours, minutes, and seconds.
class EasyTime {
  /// Number of hours.
  final int hours;

  /// Number of minutes.
  final int minutes;

  /// Number of seconds.
  final int seconds;

  /// Creates an [EasyTime] object with [hours], [minutes], and [seconds].
  const EasyTime({this.hours = 0, this.minutes = 0, this.seconds = 0});

  /// Converts the given [hours], [minutes], and [seconds] into total seconds.
  int get toSeconds => hours * 3600 + minutes * 60 + seconds;
}