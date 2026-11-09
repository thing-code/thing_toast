import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thing_toast/thing_toast.dart';

void main() {
  testWidgets('loading toast stays visible until its future completes', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (value) {
            context = value;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final Completer<String> request = Completer<String>();
    final Future<String> result = ThingToast.loading(
      context: context,
      message: 'Loading',
      future: request.future,
    );

    await tester.pump();
    expect(find.text('Loading'), findsOneWidget);

    final CircularProgressIndicator indicator = tester.widget(
      find.byType(CircularProgressIndicator),
    );
    final Theme indicatorTheme = tester.widget(
      find
          .ancestor(
            of: find.byType(CircularProgressIndicator),
            matching: find.byType(Theme),
          )
          .first,
    );
    // ignore: deprecated_member_use
    expect(indicatorTheme.data.progressIndicatorTheme.year2023, isFalse);
    expect(
      indicator.constraints,
      const BoxConstraints.tightFor(width: 24, height: 24),
    );
    expect(
      indicatorTheme.data.progressIndicatorTheme.color,
      Theme.of(context).colorScheme.onInverseSurface,
    );

    request.complete('result');
    expect(await result, 'result');

    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Loading'), findsNothing);
  });

  testWidgets('loading toast dismisses and rethrows when its future fails', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (value) {
            context = value;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final Completer<void> request = Completer<void>();
    final Future<void> result = ThingToast.loading(
      context: context,
      message: 'Saving',
      future: request.future,
    );

    await tester.pump();
    expect(find.text('Saving'), findsOneWidget);

    request.completeError(StateError('request failed'));
    await expectLater(result, throwsA(isA<StateError>()));

    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Saving'), findsNothing);
  });

  testWidgets('loading handle dismisses the toast when requested', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (value) {
            context = value;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final ToastHandle handle = ThingToast.showLoading(
      context: context,
      message: 'Saving',
    );

    await tester.pump();
    expect(find.text('Saving'), findsOneWidget);

    handle.dismiss();
    handle.dismiss();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();

    expect(find.text('Saving'), findsNothing);
  });

  testWidgets('success toast respects the requested maxLines', (tester) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (value) {
            context = value;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    ThingToast.success(
      context: context,
      message: 'A long message that can wrap onto multiple lines',
      maxLines: 3,
      duration: const Duration(milliseconds: 1),
    );

    await tester.pump();

    final Text message = tester.widget(
      find.text('A long message that can wrap onto multiple lines'),
    );
    expect(message.maxLines, 3);

    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  });
}
