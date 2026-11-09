A package for showing fancy gradient toast in Flutter applications.

## Features

Show success, info, warning, error, and loading toasts.

## Getting started

Add to your dependencies:

```yaml
dependencies:
  thing_toast: ^1.1.4
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
  message: 'This is Toast',
);
```
To Show Info Toast:

```dart
ThingToast.info(
  context,
  message: 'This is Toast',
);
```
To Show Warning Toast:

```dart
ThingToast.warning(
  context,
  message: 'This is Toast',
);
```
To Show Error Toast:

```dart
ThingToast.error(
  context,
  message: 'This is Toast',
);
```

Show a loading toast for the lifetime of an asynchronous operation. The
operation's result is returned, and any error is rethrown after the toast is
dismissed:

```dart
final result = await ThingToast.loading(
  context: context,
  message: 'Loading...',
  future: apiClient.fetchData(),
);
```

For state-driven loading (for example, reacting to a mutation's pending,
success, or error state), show the toast when the state becomes pending and
dismiss its handle when the state settles. The toast package does not depend
on Riverpod or another state-management library:

```dart
final loadingToast = ThingToast.showLoading(
  context: context,
  message: 'Saving...',
);

// In the mutation status listener, when it succeeds or fails:
loadingToast.dismiss();
```

## Additional information

Report any bugs if any via github.
