import 'package:flutter/material.dart';

import 'toast_view.dart';

/// Which edge a snack pill springs in from and stacks against.
enum ToastPosition { top, bottom }

const Color _success = Color(0xFFA5D6A7);
const Color _info = Color(0xFF90CAF9);
const Color _warning = Color(0xFFFFD54F);
const Color _error = Color(0xFFFF8A80);

enum ToastType {
  success(color: _success),
  info(color: _info),
  warning(color: _warning),
  error(color: _error);

  final Color color;

  const ToastType({required this.color});
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
