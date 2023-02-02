import 'package:flutter/material.dart';

import 'state.dart';

class BlocScreen extends StatelessWidget {
  final CounterBloc bloc;

  const BlocScreen({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CounterBlocState>(
      stream: bloc.stream,
      builder: (context, snapshot) {
        final state = snapshot.data ?? bloc.state;

        return Scaffold(
          appBar: AppBar(
            title: Text('This page uses Bloc'),
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
            onPressed: () => bloc.add(const IncrementCounterEvent()),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }
}
