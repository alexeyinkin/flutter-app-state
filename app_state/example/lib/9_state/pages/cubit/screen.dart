import 'package:flutter/material.dart';

import 'state.dart';

class CubitScreen extends StatelessWidget {
  final CounterCubit cubit;

  const CubitScreen({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CounterCubitState>(
      stream: cubit.stream,
      builder: (context, snapshot) {
        final state = snapshot.data ?? cubit.state;

        return Scaffold(
          appBar: AppBar(
            title: Text('This page uses Cubit'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '${state.counter}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: cubit.increment,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }
}
