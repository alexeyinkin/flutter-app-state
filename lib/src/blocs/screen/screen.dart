import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'close_event.dart';
import 'configuration_changed_event.dart';
import 'event.dart';

/// A BLoC that backs each stateful screen of your app.
///
/// [C] is the base class for all app's page configurations.
/// [S] is the state class of this BLoC.
abstract class ScreenBloc<C, S> {
  final _eventsController = BehaviorSubject<ScreenBlocEvent>();
  Stream<ScreenBlocEvent> get events => _eventsController.stream;

  final _statesController = BehaviorSubject<S>();
  Stream<S> get states => _statesController.stream;

  C? get currentConfiguration;

  @protected
  void emitEvent(ScreenBlocEvent event) {
    _eventsController.sink.add(event);
  }

  @protected
  void emitConfigurationChanged() {
    _eventsController.sink.add(ScreenBlocConfigurationChangedEvent());
  }

  /// Checks if this BLoC has a non-null [currentConfiguration]
  /// and emits [ScreenBlocConfigurationChangedEvent] if so.
  @protected
  void emitConfigurationChangedIfAny() {
    final configuration = currentConfiguration;
    if (configuration != null) {
      emitConfigurationChanged();
    }
  }

  /// Emits [ScreenBlocCloseEvent] for [PageStackBloc] to pop and dispose
  /// the current page.
  void closeScreen() {
    _eventsController.sink.add(ScreenBlocCloseEvent());
  }

  /// Called when Android back button is pressed with this screen active.
  ///
  /// Return [true] if this event is handled and the screen should stay.
  /// Return [false] if the screen **may** close.
  ///
  /// Closing the screen is not guaranteed. For instance, it is not closed
  /// if this is the last screen in the [PageStackBloc].
  Future<bool> onBackPressed() => Future.value(false);

  /// Creates and emits the current state of this BLoC.
  @protected
  void emitState() {
    _statesController.sink.add(createState());
  }

  /// Override this to create your BLoC's state.
  @protected
  S createState();

  /// Override this to return a map that will be recovered on navigation.
  Map<String, dynamic> get normalizedState => const <String, dynamic>{};

  /// Override this to recover the state during navigation.
  set normalizedState(Map<String, dynamic> state) {}

  @mustCallSuper
  void dispose() {
    _eventsController.close();
    _statesController.close();
  }
}
