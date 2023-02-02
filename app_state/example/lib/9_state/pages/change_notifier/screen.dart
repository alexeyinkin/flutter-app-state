import 'package:flutter/material.dart';

import 'state.dart';

class ChangeNotifierScreen extends StatelessWidget {
  final CounterChangeNotifier notifier;

  const ChangeNotifierScreen({required this.notifier});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: notifier,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: Text('This page uses ChangeNotifier'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '${notifier.counter}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: notifier.increment,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
