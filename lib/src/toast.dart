import 'package:flutter/material.dart';

import 'toast_view.dart';

/// Which edge a snack pill springs in from and stacks against.
enum ToastPosition { top, bottom }

enum ToastType {
  // Light-mode pill (dark background) → bright/pastel chip.
  // Dark-mode pill  (light background) → deeper/saturated chip.
  success(
    colorOnDark: Color(0xFFA5D6A7), // pastel green
    colorOnLight: Color(0xFF2E7D32), // green 800
  ),
  info(
    colorOnDark: Color(0xFF90CAF9), // pastel blue
    colorOnLight: Color(0xFF1565C0), // blue 800
  ),
  warning(
    colorOnDark: Color(0xFFFFD54F), // pastel amber
    colorOnLight: Color(0xFFF9A825), // yellow 800
  ),
  error(
    colorOnDark: Color(0xFFFF8A80), // pastel red
    colorOnLight: Color(0xFFC62828), // red 800
  );

  /// Chip color used on a dark pill background (light theme).
  final Color colorOnDark;

  /// Chip color used on a light pill background (dark theme).
  final Color colorOnLight;

  const ToastType({required this.colorOnDark, required this.colorOnLight});

  /// Returns the chip color that contrasts well with the current
  /// [inverseSurface] pill background.
  Color resolveColor(Brightness brightness) =>
      brightness == Brightness.dark ? colorOnLight : colorOnDark;
}

/// One shown snack and the key that reaches its live view.
class Toast {
  Toast({
    required this.message,
    this.icon,
    required this.duration,
    this.type,
    this.position = ToastPosition.bottom,
  });

  final GlobalKey<ToastViewState> key = GlobalKey();
  final String message;
  final IconData? icon;
  final Duration duration;
  final ToastType? type;

  /// Which edge this pill enters from, peeks toward, and drags off of.
  final ToastPosition position;
}
