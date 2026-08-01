import 'package:flutter/material.dart';

import 'toast.dart';
import 'toast_stack.dart';

/// Owns the live list of snacks and the single [OverlayEntry] rendering
/// them. It mounts with the first snack and unmounts when the last one
/// leaves. Top-edge and bottom-edge snacks share this one list and entry;
/// [ToastStack] is what splits them back apart into two piles.
abstract final class ToastOverlay {
  /// Max pills stacked on a single edge. Top and bottom count separately.
  static const int maxStack = 3;

  static final ValueNotifier<List<Toast>> snacks = ValueNotifier(const []);
  static OverlayEntry? _entry;

  /// Snacks that are not animating out yet. Only these count for stacking
  /// and duplicate checks.
  static List<Toast> get alive => snacks.value
      .where((s) => !(s.key.currentState?.isDismissing ?? false))
      .toList();

  /// Same as [alive], narrowed to one edge. [showExpressiveSnack] uses
  /// this so the two edges stack and overflow independently.
  static List<Toast> aliveAt(ToastPosition position) =>
      alive.where((s) => s.position == position).toList();

  static void add(Toast snack, OverlayState overlay) {
    snacks.value = [...snacks.value, snack];
    if (_entry == null) {
      _entry = OverlayEntry(builder: (context) => const ToastStack());
      overlay.insert(_entry!);
    }
  }

  /// Moves [snack] to the newest spot so its pile deals it to the front.
  /// The depth springs animate the reorder, so the pill slides forward
  /// while the others on its edge settle back.
  static void promote(Toast snack) {
    if (snacks.value.last == snack) return;
    snacks.value = [
      for (final Toast s in snacks.value)
        if (s != snack) s,
      snack,
    ];
  }

  static void remove(Toast snack) {
    snacks.value = [...snacks.value]..remove(snack);
    if (snacks.value.isEmpty) {
      _entry?.remove();
      _entry = null;
    }
  }

  /// Re-emits the list so both piles deal depths again. Called when a
  /// pill starts dismissing, so the ones behind it spring forward right
  /// away instead of waiting for its exit to finish.
  static void refresh() {
    snacks.value = List.of(snacks.value);
  }
}
