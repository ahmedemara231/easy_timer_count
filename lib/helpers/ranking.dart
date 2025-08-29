/// Defines the order in which the timer counts.
enum RankingType {
  /// Timer counts up from `0` to [EasyTime.toSeconds].
  ascending,

  /// Timer counts down from [EasyTime.toSeconds] to `0`.
  descending,
}