import 'package:flutter/material.dart';

import 'state.dart';

class InputScreen extends StatelessWidget {
  final InputPageNotifier notifier;

  const InputScreen(this.notifier);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: notifier,
      builder: _buildOnChange,
    );
  }

  Widget _buildOnChange(BuildContext context, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Your Name')),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: notifier.nameController,
              decoration: const InputDecoration(
                label: Text('Name'),
              ),
            ),
            Container(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: notifier.pop,
                ),
                Container(width: 20),
                ElevatedButton(
                  child: const Text('Save'),
                  onPressed: notifier.canSave ? notifier.onSavePressed : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
