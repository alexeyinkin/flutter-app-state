import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc.dart';
import 'configuration.dart';

/// A PageBloc that also has [states] stream.
///
/// [C] is the base class for all app's page configurations.
/// [S] is the state class of this BLoC.
abstract class PageStatefulBloc<C extends PageConfiguration, S>
    extends PageBloc<C> {
  final _statesController = BehaviorSubject<S>();

  Stream<S> get states => _statesController.stream;

  /// Creates and emits the current state of this BLoC.
  @protected
  void emitState() {
    _statesController.sink.add(createState());
  }

  /// Override this to create your BLoC's state.
  @protected
  S createState();

  @override
  void dispose() {
    _statesController.close();
    super.dispose();
  }
}
