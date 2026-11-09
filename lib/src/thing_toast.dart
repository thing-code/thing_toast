import 'package:flutter/material.dart';

import 'toast.dart';
import 'toast_overlay.dart';
import 'toast_view.dart';

abstract final class ThingToast {
  /// Shows a loading toast that stays visible until its [ToastHandle] is
  /// dismissed.
  ///
  /// Use the handle from a mutation's pending/success/error state listener to
  /// control the toast without coupling this package to a state-management
  /// library.
  static ToastHandle showLoading({
    required BuildContext context,
    required String message,
    int? maxLines,
    ToastPosition position = ToastPosition.bottom,
  }) => ToastHandle._(
    _showToast(
      context: context,
      message: message,
      duration: null,
      position: position,
      isLoading: true,
      maxLines: maxLines,
    ),
  );

  /// Shows a loading toast until [future] completes, then returns its result
  /// or rethrows its error.
  static Future<T> loading<T>({
    required BuildContext context,
    required String message,
    required Future<T> future,
    int? maxLines,
    ToastPosition position = ToastPosition.bottom,
  }) async {
    final ToastHandle handle = showLoading(
      context: context,
      message: message,
      position: position,
      maxLines: maxLines,
    );

    try {
      return await future;
    } finally {
      handle.dismiss();
    }
  }

  static void success({
    required BuildContext context,
    required String message,
    int? maxLines,
    IconData? icon,
    // Spec: snackbars stay visible 4-10 seconds.
    Duration duration = const Duration(seconds: 4),
    ToastPosition position = ToastPosition.bottom,
  }) => _showToast(
    context: context,
    message: message,
    maxLines: maxLines,
    duration: duration,
    icon: icon,
    position: position,
    type: .success,
  );

  static void info({
    required BuildContext context,
    required String message,
    int? maxLines,
    IconData? icon,
    // Spec: snackbars stay visible 4-10 seconds.
    Duration duration = const Duration(seconds: 4),
    ToastPosition position = ToastPosition.bottom,
  }) => _showToast(
    context: context,
    message: message,
    maxLines: maxLines,
    duration: duration,
    icon: icon,
    position: position,
    type: .info,
  );

  static void warning({
    required BuildContext context,
    required String message,
    int? maxLines,
    IconData? icon,
    // Spec: snackbars stay visible 4-10 seconds.
    Duration duration = const Duration(seconds: 4),
    ToastPosition position = ToastPosition.bottom,
  }) => _showToast(
    context: context,
    message: message,
    maxLines: maxLines,
    duration: duration,
    icon: icon,
    position: position,
    type: .warning,
  );

  static void error({
    required BuildContext context,
    required String message,
    int? maxLines,
    IconData? icon,
    // Spec: snackbars stay visible 4-10 seconds.
    Duration duration = const Duration(seconds: 4),
    ToastPosition position = ToastPosition.bottom,
  }) => _showToast(
    context: context,
    message: message,
    maxLines: maxLines,
    duration: duration,
    icon: icon,
    position: position,
    type: .error,
  );
}

/// A handle for manually dismissing a loading toast.
///
/// Calling [dismiss] more than once is safe.
final class ToastHandle {
  ToastHandle._(this._snack);

  final Toast? _snack;
  bool _dismissed = false;

  /// Dismisses the toast. Has no effect if it was already dismissed.
  void dismiss() {
    if (_dismissed) return;
    _dismissed = true;
    final Toast? snack = _snack;
    if (snack != null) ToastOverlay.dismiss(snack);
  }
}

/// Shows an expressive snack: a floating pill that springs in from
/// [position]'s edge (expressive spatial in, standard fast out). When
/// [icon] is given, an arch shaped chip sits on the pill's rounded left
/// end.
///
/// Repeated calls stack like cards on their own edge. The newest pill
/// lands in front and older ones move back, peeking out past it, up to
/// three deep. Past that the oldest one on that edge leaves. Top and
/// bottom piles stack and overflow independently, so a call with
/// [ToastPosition.top] never bumps a pill already stacked at the bottom.
/// If [message] and [icon] match a pill already on screen at the same
/// [position], no new pill is added. That pill shakes and its countdown
/// restarts. Tap or flick a pill to dismiss it early. Each one dismisses
/// itself after its [duration].
///
/// Colors and text styles come from the ambient [Theme], following
/// [SnackBar]: an inverse surface container with body medium text.
Toast? _showToast({
  required BuildContext context,
  required String message,
  int? maxLines,
  IconData? icon,
  // Spec: snackbars stay visible 4-10 seconds.
  Duration? duration = const Duration(seconds: 4),
  ToastPosition position = ToastPosition.bottom,
  ToastType? type,
  bool isLoading = false,
}) {
  if (!context.mounted) return null;

  final OverlayState? overlay = Overlay.maybeOf(context, rootOverlay: true);

  assert(overlay != null, 'ThingToast: no Overlay found above this context.');

  if (overlay == null) return null;

  final List<Toast> alive = ToastOverlay.aliveAt(position);

  // A duplicate does not add a pill. The one already saying it comes to
  // the front and shakes. The forward slide and the sideways wobble run
  // on separate axes, so together they read as one smooth pull-and-shake.
  if (!isLoading) {
    for (final Toast snack in alive) {
      if (snack.message == message && snack.icon == icon) {
        ToastOverlay.promote(snack);
        snack.key.currentState?.shake();
        return snack;
      }
    }
  }

  // A full pile makes room: the oldest pill on this edge starts leaving
  // now and stops counting, so the newcomer never waits.
  if (alive.length >= ToastOverlay.maxStack) {
    final ToastViewState? oldest = alive.first.key.currentState;
    if (oldest != null) {
      oldest.dismiss();
    } else {
      ToastOverlay.remove(alive.first);
    }
  }

  final Toast snack = Toast(
    message: message,
    icon: icon,
    duration: duration,
    position: position,
    type: type,
    maxLines: maxLines,
    isLoading: isLoading,
  );
  ToastOverlay.add(snack, overlay);
  return snack;
}
