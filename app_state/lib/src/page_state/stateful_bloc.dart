import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'page_state_mixin.dart';
import 'path.dart';

/// A [PPageStateMixin] implementation for your pages that uses
/// a simple custom BLoC implementation.
///
/// [P] is the base class for all app's page paths.
/// [R] is the result returned when the page pops.
/// [S] is the state class of this BLoC.
// TODO(alexeyinkin): Rename to PageBloc when the current PageBloc
//  is removed in v0.8.0,
//  https://github.com/alexeyinkin/flutter-app-state/issues/13
abstract class PPageStatefulBloc<P extends PagePath, S, R>
    with PPageStateMixin<P, R> {
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
  Future<void> dispose() async {
    await _statesController.close();
    await super.dispose();
  }
}

typedef PageStatefulBloc<S, R> = CPageStatefulBloc<PagePath, S, R>;

typedef CPageStatefulBloc<P extends PagePath, S, R>
    = PPageStatefulBloc<P, S, R>;
