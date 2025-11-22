import 'package:flutter/widgets.dart';
import 'package:thing_toast/src/toast_type.dart';

/// Additional Syle for Toast
class ToastStyle {
  /// Custom Title Text Style
  final TextStyle? titleTextStyle;

  /// Custom Subtitle Text Style
  final TextStyle? messageTextStyle;

  const ToastStyle({this.titleTextStyle, this.messageTextStyle});
}

/// Parameter Class for Toast
class ToastParams {
  // Toast Id
  final String id;

  /// Toast Title
  final String? title;

  /// Duration of showing Toast
  final Duration duration;

  /// Toast Subtitle
  final String message;

  /// Type of the Toast
  final ToastType type;

  /// Additional Style for Toast
  final ToastStyle style;

  /// Additional Suffix Icon for Toast
  final Widget? icon;

  const ToastParams({
    this.title,
    required this.duration,
    required this.message,
    this.icon,
    required this.type,
    this.style = const ToastStyle(),
    required this.id,
  });
}
