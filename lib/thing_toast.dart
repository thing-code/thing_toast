import 'package:flutter/material.dart';
import 'package:thing_toast/src/toast_params.dart';
import 'package:thing_toast/src/toast_type.dart';
import 'package:thing_toast/src/toast_wrapper.dart';
import 'package:uuid/v4.dart';

/// Class To Call Toast
class ThingToast {
  static final ThingToast _instance = ThingToast._internal();
  factory ThingToast() => _instance;
  ThingToast._internal();

  /// State of toast list
  final ValueNotifier<List<ToastParams>> notifier = ValueNotifier([]);
  OverlayEntry? _overlayEntry;

  /// Function to show success toast
  static void success(
    BuildContext context, {
    required String message,
    String? title,
    Widget? icon,
    Duration duration = const Duration(seconds: 4),
  }) {
    _instance._show(context, message, title, icon, ToastType.success, duration);
  }

  /// Function to show warning toast
  static void warning(
    BuildContext context, {
    required String message,
    String? title,
    Widget? icon,
    Duration duration = const Duration(seconds: 4),
  }) {
    _instance._show(context, message, title, icon, ToastType.warning, duration);
  }

  /// Function to show info toast
  static void info(
    BuildContext context, {
    required String message,
    String? title,
    Widget? icon,
    Duration duration = const Duration(seconds: 4),
  }) {
    _instance._show(context, message, title, icon, ToastType.info, duration);
  }

  /// Function to show error toast
  static void error(
    BuildContext context, {
    required String message,
    String? title,
    Widget? icon,
    Duration duration = const Duration(seconds: 4),
  }) {
    _instance._show(context, message, title, icon, ToastType.error, duration);
  }

  /// Function to dismiss toast manually
  static void dismiss(String id) {
    _instance._removeToast(id);
  }

  // Base Function to show a toast
  void _show(
    BuildContext context,
    String message,
    String? title,
    Widget? icon,
    ToastType type,
    Duration duration,
  ) {
    // Check overlayEntry
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry(context);
      Overlay.of(context).insert(_overlayEntry!);
    }

    // Set parameter for toast with unique id
    final newToast = ToastParams(
      id: UuidV4().generate(),
      message: message,
      title: title,
      type: type,
      icon: icon,
      duration: duration,
    );

    final currentList = List<ToastParams>.from(notifier.value);
    currentList.insert(0, newToast);
    notifier.value = currentList;
  }

  void _removeToast(String id) {
    final currentList = List<ToastParams>.from(notifier.value);
    currentList.removeWhere((element) => element.id == id);
    notifier.value = currentList;

    if (currentList.isEmpty) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (notifier.value.isEmpty && _overlayEntry != null) {
          _overlayEntry?.remove();
          _overlayEntry = null;
        }
      });
    }
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    // [BARU] Ambil padding atas (SafeArea)
    final topPadding = MediaQuery.of(context).padding.top;

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: topPadding,
          left: 0,
          right: 0,
          // Widget ini sekarang akan menghitung lebar layar sendiri
          child: const ToastStackManager(),
        );
      },
    );
  }
}
