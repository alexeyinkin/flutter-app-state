import 'package:flutter/material.dart';

import '../../main.dart';
import '../bloc/page.dart';
import '../change_notifier/page.dart';
import '../cubit/page.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Open a Counter Page with")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: const Text("Bloc"),
              onPressed: () => pageStack.push(BlocPage(initialCount: 0)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("ChangeNotifier"),
              onPressed: () =>
                  pageStack.push(ChangeNotifierPage(initialCount: 0)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Cubit"),
              onPressed: () => pageStack.push(CubitPage(initialCount: 0)),
            ),
          ],
        ),
      ),
    );
  }
}
