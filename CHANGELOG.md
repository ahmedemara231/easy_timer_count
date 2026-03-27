## 0.0.4

* Initial release of `easy_timer_count`.
* Added `EasyTimerCount` widget for countdown / count-up timer display.
* Added `EasyTime` class for setting duration with hours, minutes, seconds.
* Added `EasyTimerController` to control the timer (start, stop, reset, resume, restart).
* Added support for ascending / descending ranking (`RankingType`).
* Added support for separators (colon, dashed, none).
* Added customization options for:
    * Text color, font, weight, size, spacing, decoration, locale, background
    * Custom builder for fully custom UI
* Added lifecycle callbacks:l
    * `onTimerStarts`
    * `onTimerEnds`
    * `onTimerRestart` (when auto-restarting is enabled)
* Added options for `resetTimer` and `reCountAfterFinishing`.
