import 'package:flutter/material.dart';
import 'package:thing_toast/src/colors.dart';
import 'package:thing_toast/src/toast_type.dart';

/// The main widget of the toast
class ToastWidget extends StatelessWidget {
  const ToastWidget({
    super.key,
    this.title,
    required this.type,
    required this.message,
    this.titleTextStyle,
    this.messageTextStyle,
    this.icon,
  });

  final String? title;
  final String message;
  final TextStyle? titleTextStyle;
  final TextStyle? messageTextStyle;
  final Widget? icon;
  final ToastType type;

  @override
  Widget build(BuildContext context) {
    var boxShadow = [
      const BoxShadow(
        color: Color.fromRGBO(0, 0, 0, .05),
        blurRadius: 28,
        spreadRadius: 8,
        offset: Offset(0, 9),
      ),
      const BoxShadow(
        color: Color.fromRGBO(0, 0, 0, .12),
        blurRadius: 6,
        spreadRadius: -4,
        offset: Offset(0, 3),
      ),
      const BoxShadow(
        color: Color.fromRGBO(0, 0, 0, .08),
        blurRadius: 16,
        spreadRadius: 0,
        offset: Offset(0, 6),
      ),
    ];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      constraints: BoxConstraints(
        minHeight: 48,
        maxHeight: 150,
        maxWidth: MediaQuery.sizeOf(context).width - 32,
      ),
      decoration: BoxDecoration(
        gradient: type.gradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: type.color,
          width: 1,
          strokeAlign: BorderSide.strokeAlignCenter,
        ),
        boxShadow: boxShadow,
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        type: MaterialType.transparency,
        child: Row(
          spacing: 12,
          children: [
            ?icon,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ?_title,
                  Text(
                    message,
                    style:
                        messageTextStyle ??
                        TextStyle(fontSize: 12, color: subtitleColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? get _title {
    if (title == null) return null;
    return Text(
      title!,
      style:
          titleTextStyle ??
          TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: titleColor,
          ),
    );
  }
}
