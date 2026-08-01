import 'package:flutter/material.dart';

import 'toast.dart';
import 'toast_overlay.dart';
import 'toast_view.dart';

/// The single overlay entry: every live pill bottom- or top-anchored
/// depending on its own [ToastPosition], each rendering itself at its
/// dealt depth (0 = front) like a card stack. The top pile and the bottom
/// pile stack and overflow independently, so both can be on screen and
/// three deep at once without affecting each other.
class ToastStack extends StatelessWidget {
  const ToastStack({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Stack(
        children: [
          _ToastPile(position: ToastPosition.top),
          _ToastPile(position: ToastPosition.bottom),
        ],
      ),
    );
  }
}

/// One edge's pile: filters the shared snack list down to its own
/// [position], deals depths among just those, and lays them out anchored
/// to that edge.
class _ToastPile extends StatelessWidget {
  const _ToastPile({required this.position});

  final ToastPosition position;

  @override
  Widget build(BuildContext context) {
    final bool bottom = position == ToastPosition.bottom;

    return Align(
      alignment: bottom ? Alignment.bottomCenter : Alignment.topCenter,
      child: Padding(
        // The keyboard reports through viewInsets, which SafeArea does
        // not cover. Without this a snack shown while typing hides
        // behind the keyboard. Only the bottom edge needs to dodge it.
        padding: EdgeInsets.fromLTRB(
          16,
          bottom ? 0 : 16,
          16,
          bottom ? 16 + MediaQuery.viewInsetsOf(context).bottom : 0,
        ),
        child: ValueListenableBuilder(
          valueListenable: ToastOverlay.snacks,
          builder: (context, allSnacks, _) {
            final List<Toast> snacks = [
              for (final Toast snack in allSnacks)
                if (snack.position == position) snack,
            ];

            // Deal depths newest-first; a dismissing pill holds its spot
            // without claiming one, so the pile behind it moves up.
            int next = 0;
            final Map<Toast, int> depths = {
              for (final Toast snack in snacks.reversed)
                snack: (snack.key.currentState?.isDismissing ?? false)
                    ? next
                    : next++,
            };

            return Stack(
              alignment: bottom ? Alignment.bottomCenter : Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                for (final Toast snack in snacks)
                  ToastView(
                    key: snack.key,
                    snack: snack,
                    depth: depths[snack]!,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
