## 1.1.0
BREAKING CHANGES
* Full rewrite of the toast implementation into an expressive Material 3 pill with spring physics (via `motor`).
* `ThingToast` is now an `abstract final` class with static methods only; the singleton/factory pattern is removed.
* `BuildContext` is now a named required parameter (`context:`).
* `icon` now accepts `IconData?` instead of `Widget?`.
* Replace the `title` and `subtitle` parameter with a single `message` parameter.
* Removed `ThingToast.dismiss(String id)`.
* Added `position` parameter (`ToastPosition.top` / `ToastPosition.bottom`, default `bottom`).
* Minimum dart sdk version `3.12.0`.

New features
* Stacked toasts like a card stack, up to 3 deep per edge; top and bottom piles stack and overflow independently.
* Duplicate detection: showing the same message and icon again shakes the existing toast and restarts its countdown instead of adding a new one.
* Drag or fling to dismiss, tap to dismiss, and holding pauses the auto-dismiss countdown.
* Bottom toasts float above the keyboard via `viewInsets`.
* Arch-shaped icon chip colored by toast type (success, info, warning, error).
* Theming follows `SnackBar`: inverse surface container with body medium text, plus `Semantics.liveRegion` for accessibility.

## 1.0.3
* Adjust ToastWidget height and padding
* minimum dart sdk version `3.11.0`

## 1.0.2
* Decrease border width from 1.5 to 1
* Add more space on top of the toast

## 1.0.1
BREAKING CHANGES
* minimum dart sdk version `3.10.0`.
* move `BuildContext` from constructor to each function.
* update description

## 1.0.0
First Major Version with a lot of improvement at style and behaviour.
Inspired by Sonner from Shadcn.
* Implement sonner style (Stacked Toast)
* New animations
* remove `ToastPosition`, default position at the top

## 0.4.0
* Add Custom Widget Icon parameters.

## 0.3.0
* Remove `iconsax_plus` dependency.

## 0.2.0
* Fix issue on Android Plafrom where Toast was not showing correctly.
* Add support for iOS Platform.
* Refactor codebase.
* Update example app.
* Update documentation.
* Add Example app screenshots to README.md.

## 0.1.0

* Initial release of Thing Toast.
