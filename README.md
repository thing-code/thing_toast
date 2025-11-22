A package for showing fancy gradient toast in Flutter applications.

## Features

Show 4 Type of Toast : Success, Info, Warning and Error.

| Plaform      | Preview      |
|--------------|--------------|
| iOS | <img src="screenshots/ios-toast.gif" width="300" /> |
| Android | <img src="screenshots/android-toast.gif" width="300" /> |

## Getting started

Add to your dependencies:

```yaml
dependencies:
  thing_toast: ^1.0.0
```

Then import:

```dart
import 'package:thing_toast/thing_toast.dart';
```

## Usage

To Show Success Toast:

```dart
ThingToast.success(
  context,
  title: 'This is Toast',
  subtitle: 'This is the description',
);
```
To Show Info Toast:

```dart
ThingToast.info(
  context,
  title: 'This is Toast',
  subtitle: 'This is the description',
);
```
To Show Warning Toast:

```dart
ThingToast.warning(
  context,
  title: 'This is Toast',
  subtitle: 'This is the description',
);
```
To Show Error Toast:

```dart
ThingToast.error(
  context,
  title: 'This is Toast',
  subtitle: 'This is the description',
);
```

## Additional information

Report any bugs if any via github.
