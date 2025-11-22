import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thing_toast/src/toast_params.dart';
import 'package:thing_toast/src/toast_widget.dart';
import 'package:thing_toast/thing_toast.dart';

/// Widget for toast animation and position
class ToastStackManager extends StatelessWidget {
  const ToastStackManager({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ValueListenableBuilder<List<ToastParams>>(
      valueListenable: ThingToast().notifier,
      builder: (context, toasts, child) {
        final visibleToasts = toasts.take(3).toList();

        return Center(
          child: SizedBox(
            width: screenWidth, // Lebar dinamis
            height: 150,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                for (int i = visibleToasts.length - 1; i >= 0; i--)
                  _ToastCardAnimationWrapper(
                    key: ValueKey(visibleToasts[i].id),
                    data: visibleToasts[i],
                    index: i,
                    isFront: i == 0,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Widget to control animation of the toast
class _ToastCardAnimationWrapper extends StatefulWidget {
  final ToastParams data;
  final int index;
  final bool isFront;

  const _ToastCardAnimationWrapper({
    required Key key,
    required this.data,
    required this.index,
    required this.isFront,
  }) : super(key: key);

  @override
  State<_ToastCardAnimationWrapper> createState() =>
      _ToastCardAnimationWrapperState();
}

class _ToastCardAnimationWrapperState
    extends State<_ToastCardAnimationWrapper> {
  Timer? _timer;
  bool _isHovered = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(widget.data.duration, () {
      if (!_isHovered && !_isDragging) {
        ThingToast.dismiss(widget.data.id);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double scale = 1.0 - (widget.index * 0.05);
    final double topOffset = widget.index * 14.0;
    final double hoverTopOffset = widget.index * 45.0;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      top: _isHovered ? hoverTopOffset : topOffset,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        scale: scale,
        alignment: Alignment.topCenter,
        child: Dismissible(
          key: ValueKey(widget.data.id),
          direction: DismissDirection.up,
          onDismissed: (_) {
            ThingToast.dismiss(widget.data.id);
          },
          onResize: () => _isDragging = true,
          child: MouseRegion(
            onEnter: (_) {
              setState(() => _isHovered = true);
              _timer?.cancel();
            },
            onExit: (_) {
              setState(() => _isHovered = false);
              _startTimer();
            },
            child: GestureDetector(
              onLongPressDown: (_) {
                setState(() => _isDragging = true);
                _timer?.cancel();
              },
              onLongPressEnd: (_) {
                setState(() => _isDragging = false);
                _startTimer();
              },
              // [BARU] Kirim width ke content
              child: ToastWidget(
                message: widget.data.message,
                type: widget.data.type,
                icon: widget.data.icon,
                title: widget.data.title,
                titleTextStyle: widget.data.style.titleTextStyle,
                messageTextStyle: widget.data.style.messageTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
