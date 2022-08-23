import 'package:app_state/app_state.dart';
import 'package:bloc/bloc.dart';

import 'path.dart';

class CounterCubit extends Cubit<CounterCubitState> with PageStateMixin<void> {
  int _counter;

  CounterCubit({
    required int initialCount,
  })  : _counter = initialCount,
        super(CounterCubitState(counter: initialCount));

  void increment() {
    _counter++;
    emitPathChanged();
    emit(_createState());
  }

  @override
  PagePath get path => CubitPath(counter: _counter);

  @override
  void setStateMap(Map<String, dynamic> state) {
    _counter = state['counter'];
    emitPathChanged();
    emit(_createState());
  }

  CounterCubitState _createState() => CounterCubitState(counter: _counter);
}

class CounterCubitState {
  final int counter;

  const CounterCubitState({
    required this.counter,
  });
}
