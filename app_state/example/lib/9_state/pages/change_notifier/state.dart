import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import 'path.dart';

class CounterChangeNotifier extends ChangeNotifier with PageStateMixin<void> {
  int _counter;

  int get counter => _counter;

  CounterChangeNotifier({
    required int initialCount,
  }) : _counter = initialCount;

  void increment() {
    _counter++;
    emitPathChanged();
    notifyListeners();
  }

  @override
  PagePath get path => ChangeNotifierPath(counter: _counter);

  @override
  void setStateMap(Map<String, dynamic> state) {
    _counter = state['counter'];
    notifyListeners();
  }
}
