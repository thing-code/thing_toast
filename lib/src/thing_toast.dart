import 'package:flutter/material.dart';

import 'toast.dart';
import 'toast_overlay.dart';
import 'toast_view.dart';

abstract final class ThingToast {
  static void success({
    required BuildContext context,
    required String message,
    IconData? icon,
    // Spec: snackbars stay visible 4-10 seconds.
    Duration duration = const Duration(seconds: 4),
    ToastPosition position = ToastPosition.bottom,
  }) => _showToast(
    context: context,
    message: message,
    duration: duration,
    icon: icon,
    position: position,
    type: .success,
  );

  static void info({
    required BuildContext context,
    required String message,
    IconData? icon,
    // Spec: snackbars stay visible 4-10 seconds.
    Duration duration = const Duration(seconds: 4),
    ToastPosition position = ToastPosition.bottom,
  }) => _showToast(
    context: context,
    message: message,
    duration: duration,
    icon: icon,
    position: position,
    type: .info,
  );

  static void warning({
    required BuildContext context,
    required String message,
    IconData? icon,
    // Spec: snackbars stay visible 4-10 seconds.
    Duration duration = const Duration(seconds: 4),
    ToastPosition position = ToastPosition.bottom,
  }) => _showToast(
    context: context,
    message: message,
    duration: duration,
    icon: icon,
    position: position,
    type: .warning,
  );

  static void error({
    required BuildContext context,
    required String message,
    IconData? icon,
    // Spec: snackbars stay visible 4-10 seconds.
    Duration duration = const Duration(seconds: 4),
    ToastPosition position = ToastPosition.bottom,
  }) => _showToast(
    context: context,
    message: message,
    duration: duration,
    icon: icon,
    position: position,
    type: .error,
  );
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
void _showToast({
  required BuildContext context,
  required String message,
  IconData? icon,
  // Spec: snackbars stay visible 4-10 seconds.
  Duration duration = const Duration(seconds: 4),
  ToastPosition position = ToastPosition.bottom,
  ToastType? type,
}) {
  if (!context.mounted) return;

  final OverlayState? overlay = Overlay.maybeOf(context, rootOverlay: true);

  assert(overlay != null, 'ThingToast: no Overlay found above this context.');

  if (overlay == null) return;

  final List<Toast> alive = ToastOverlay.aliveAt(position);

  // A duplicate does not add a pill. The one already saying it comes to
  // the front and shakes. The forward slide and the sideways wobble run
  // on separate axes, so together they read as one smooth pull-and-shake.
  for (final Toast snack in alive) {
    if (snack.message == message && snack.icon == icon) {
      ToastOverlay.promote(snack);
      snack.key.currentState?.shake();
      return;
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

  ToastOverlay.add(
    Toast(
      message: message,
      icon: icon,
      duration: duration,
      position: position,
      type: type,
    ),
    overlay,
  );
}
