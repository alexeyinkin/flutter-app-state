import 'package:flutter/material.dart';

import '../../main.dart';
import '../input/page.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: ElevatedButton(
          child: const Text("Open Input"),
          onPressed: () => pageStack.push(InputPage()),
        ),
      ),
    );
  }
}
