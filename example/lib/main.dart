import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thing_toast/thing_toast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoApp(
        title: 'Thing Toast App',
        theme: CupertinoThemeData(primaryColor: Colors.indigo),
        home: const HomePage(),
      );
    }

    return MaterialApp(
      title: 'Thing Toast App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(middle: Text('Thing Toast'))
          : AppBar(title: Text('Thing Toast')),
      body: SafeArea(
        child: Padding(
          padding: const .all(16.0),
          child: SizedBox.expand(
            child: Column(
              spacing: 12,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: () {
                    ThingToast.success(
                      context: context,
                      message: "This is the snack",
                      icon: Icons.info,
                    );
                  },
                  child: Text('Show Toast'),
                ),
                FilledButton(
                  onPressed: () {
                    ThingToast.info(
                      context: context,
                      maxLines: 3,
                      message: "This is the wallhack. fsosdafhasopoacaosoocvasoioidasui caiviaisus vasisidsai vasidsadisai vasidasdoi",
                      icon: Icons.wallet,
                    );
                  },
                  child: Text('Show Toast'),
                ),
                FilledButton(
                  onPressed: () async {
                    await ThingToast.loading(
                      context: context,
                      message: 'Fetching data...',
                      future: Future<String>.delayed(
                        const Duration(seconds: 2),
                        () => 'Data loaded',
                      ),
                    );
                    if (!context.mounted) return;
                    ThingToast.success(
                      context: context,
                      message: 'Data loaded',
                    );
                  },
                  child: const Text('Loading with Future'),
                ),
                FilledButton(
                  onPressed: () async {
                    final ToastHandle loadingToast = ThingToast.showLoading(
                      context: context,
                      message: 'Saving...',
                    );
                    try {
                      await Future<void>.delayed(const Duration(seconds: 2));
                      if (!context.mounted) return;
                      ThingToast.success(context: context, message: 'Saved');
                    } finally {
                      loadingToast.dismiss();
                    }
                  },
                  child: const Text('Loading with handle'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
