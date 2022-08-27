import 'package:flutter/material.dart';

import 'state.dart';

class AboutScreen extends StatelessWidget {
  final AboutPageNotifier notifier;

  const AboutScreen(this.notifier);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: notifier,
      builder: _buildOnChange,
    );
  }

  Widget _buildOnChange(BuildContext context, Widget? child) {
    final text = notifier.name == ''
        ? 'This software is not licensed.'
        : 'This software is licensed to ${notifier.name}.';

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(text),
            Container(height: 20),
            ElevatedButton(
              child: const Text('License'),
              onPressed: notifier.onLicensePressed,
            ),
          ],
        ),
      ),
    );
  }
}
