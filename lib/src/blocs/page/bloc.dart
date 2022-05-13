import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'close_event.dart';
import 'configuration.dart';
import 'configuration_changed_event.dart';
import 'event.dart';
import '../../models/back_pressed_result_enum.dart';

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
    _eventsController.sink.add(const PageBlocConfigurationChangedEvent());
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
    _eventsController.sink.add(const PageBlocCloseEvent());
  }

  /// Emits [event] for [PageStackBloc] to remove and dispose the current page.
  /// [event] is passed to the new topmost [PageBloc] and can be used
  /// as modal dialog result.
  void closeScreenWith(PageBlocCloseEvent event) {
    _eventsController.sink.add(event);
  }

  /// Override this to use the result of a closed modal screen.
  void onForegroundClosed(PageBlocCloseEvent event) {}

  /// Called when Android back button is pressed with this page active.
  ///
  /// Override this to handle the event and to prevent the screen from closing.
  /// The closing itself is done in [PageStackBlocNavigator] so this method
  /// only has to return the decision.
  ///
  /// Closing is not guaranteed. For instance, it is not closed
  /// if this is the last page in the [PageStackBloc].
  Future<BackPressedResult> onBackPressed() {
    return Future.value(BackPressedResult.close);
  }

  /// Override this to recover the state during navigation.
  void setStateMap(Map<String, dynamic> state) {}

  @mustCallSuper
  void dispose() {
    _eventsController.close();
  }
}
