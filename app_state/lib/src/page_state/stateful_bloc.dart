import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'page_state_mixin.dart';
import 'path.dart';

@Deprecated(
  'Create your own custom class or mix the Bloc from the bloc package. '
  'This solution is opinionated and limited and will not be maintained.',
)
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

@Deprecated(
  'Create your own custom class or mix the Bloc from the bloc package. '
  'This solution is opinionated and limited and will not be maintained.',
)
typedef PageStatefulBloc<S, R> = CPageStatefulBloc<PagePath, S, R>;

@Deprecated(
  'Create your own custom class or mix the Bloc from the bloc package. '
  'This solution is opinionated and limited and will not be maintained.',
)
typedef CPageStatefulBloc<P extends PagePath, S, R>
    = PPageStatefulBloc<P, S, R>;
