import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'close_event.dart';
import 'configuration.dart';
import 'configuration_changed_event.dart';
import 'event.dart';

/// A BLoC that backs each stateful page of your app.
///
/// [C] is the base class for all app's page configurations.
class PageBloc<C extends PageConfiguration> {
  final _eventsController = BehaviorSubject<PageBlocEvent>();
  Stream<PageBlocEvent> get events => _eventsController.stream;

  C? getConfiguration() => null;

  @protected
  void emitEvent(PageBlocEvent event) {
    _eventsController.sink.add(event);
  }

  @protected
  void emitConfigurationChanged() {
    _eventsController.sink.add(PageBlocConfigurationChangedEvent());
  }

  /// Checks if this BLoC has a non-null current configuration
  /// and emits [PageBlocConfigurationChangedEvent] if so.
  @protected
  void emitConfigurationChangedIfAny() {
    final configuration = getConfiguration();
    if (configuration != null) {
      emitConfigurationChanged();
    }
  }

  /// Emits [PageBlocCloseEvent] for [PageStackBloc] to remove and dispose
  /// the current page.
  void closeScreen() {
    _eventsController.sink.add(PageBlocCloseEvent());
  }

  /// Called when Android back button is pressed with this page active.
  ///
  /// Return [true] if this event is handled and the page should stay.
  /// Return [false] if the page **may** close.
  ///
  /// Closing is not guaranteed. For instance, it is not closed
  /// if this is the last page in the [PageStackBloc].
  Future<bool> onBackPressed() => Future.value(false);

  /// Override this to recover the state during navigation.
  void setStateMap(Map<String, dynamic> state) {}

  @mustCallSuper
  void dispose() {
    _eventsController.close();
  }
}
