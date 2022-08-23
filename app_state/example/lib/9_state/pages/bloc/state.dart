import 'package:app_state/app_state.dart';
import 'package:bloc/bloc.dart';

import 'path.dart';

abstract class CounterEvent {
  const CounterEvent();
}

class IncrementCounterEvent extends CounterEvent {
  const IncrementCounterEvent();
}

class LoadStateCounterEvent extends CounterEvent {
  final Map<String, dynamic> state;

  const LoadStateCounterEvent({required this.state});
}

class CounterBloc extends Bloc<CounterEvent, CounterBlocState>
    with PageStateMixin<void> {
  int _counter;

  CounterBloc({
    required int initialCount,
  })  : _counter = initialCount,
        super(CounterBlocState(counter: initialCount)) {
    on<IncrementCounterEvent>((event, emit) {
      _counter++;
      emitPathChanged();
      emit(_createState());
    });

    on<LoadStateCounterEvent>((event, emit) {
      _counter = event.state['counter'];
      emitPathChanged();
      emit(_createState());
    });
  }

  @override
  PagePath get path => BlocPath(counter: _counter);

  @override
  void setStateMap(Map<String, dynamic> state) {
    add(LoadStateCounterEvent(state: state));
  }

  CounterBlocState _createState() => CounterBlocState(counter: _counter);
}

class CounterBlocState {
  final int counter;

  const CounterBlocState({
    required this.counter,
  });
}
