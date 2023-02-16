import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../models/back_pressed_result_enum.dart';
import '../page_stack/page_stack.dart';
import '../pages/abstract.dart';
import '../widgets/navigator.dart';
import 'event.dart';
import 'path.dart';
import 'path_changed_event.dart';
import 'pop_cause.dart';
import 'pop_event.dart';

/// Makes the stateful objects that back your screens
/// aware of the page stacking.
///
/// [P] is the base class for all app's paths.
/// [R] is the result returned when the page pops.
mixin PPageStateMixin<P extends PagePath, R> {
  final _eventsController = BehaviorSubject<PageEvent>();

  PageStack? pageStack;

  Stream<PageEvent> get events => _eventsController.stream;

  P? get path => null;

  @protected
  @visibleForTesting
  void emitEvent(PageEvent event) {
    _eventsController.sink.add(event);
  }

  @protected
  void emitPathChanged() {
    _eventsController.sink.add(const PagePathChangedEvent());
  }

  /// Checks if this BLoC has a non-null current path
  /// and emits [PagePathChangedEvent] if so.
  @protected
  void emitPathChangedIfAny() {
    final currentPath = path;
    if (currentPath != null) {
      emitPathChanged();
    }
  }

  /// Emits [PagePopEvent] for [PageStack] to remove and dispose
  /// the current page. [data] is passed to the new topmost [PageStateMixin] and
  /// can be used as the modal dialog result.
  void pop([R? data]) {
    _eventsController.sink.add(
      PagePopEvent<R>(
        data: data,
        cause: PopCause.page,
      ),
    );
  }

  /// Override this to use the result of a closed modal screen.
  void didPopNext(AbstractPage page, PagePopEvent event) {}

  /// Called when Android back button is pressed with this page active.
  ///
  /// Override this to handle the event and to prevent the screen from closing.
  /// The closing itself is done in [PageStackNavigator] so this method
  /// only has to return the decision.
  ///
  /// Closing is not guaranteed. For instance, it is not closed
  /// if this is the last page in the [PageStack].
  Future<BackPressedResult> onBackPressed() {
    return Future.value(BackPressedResult.close);
  }

  /// Override this to recover the state during navigation.
  void setStateMap(Map<String, dynamic> state) {}

  @mustCallSuper
  Future<void> dispose() async {
    await _eventsController.close();
  }
}

typedef PageStateMixin<R> = PPageStateMixin<PagePath, R>;
