import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/back_pressed_result_enum.dart';
import '../../pages/abstract.dart';
import '../../widgets/navigator.dart';
import '../page_stack/bloc.dart';
import 'event.dart';
import 'path.dart';
import 'path_changed_event.dart';
import 'pop_cause.dart';
import 'pop_event.dart';

/// A BLoC that backs each stateful page of your app.
///
/// [P] is the base class for all app's paths.
/// [R] is the result returned when the page pops.
class CPageBloc<P extends PagePath, R> {
  final _eventsController = BehaviorSubject<PageBlocEvent>();

  Stream<PageBlocEvent> get events => _eventsController.stream;

  P? get path =>
      getConfiguration(); // ignore: deprecated_member_use_from_same_package

  @Deprecated('Use "path" getter. See CHANGELOG for v0.6.2')
  @nonVirtual
  P? getConfiguration() => null;

  @protected
  @visibleForTesting
  void emitEvent(PageBlocEvent event) {
    _eventsController.sink.add(event);
  }

  @protected
  void emitPathChanged() =>
      emitConfigurationChanged(); // ignore: deprecated_member_use_from_same_package

  @protected
  @Deprecated('Renamed to emitPathChanged, see CHANGELOG for v0.6.2')
  @nonVirtual
  void emitConfigurationChanged() {
    _eventsController.sink.add(const PageBlocPathChangedEvent());
  }

  /// Checks if this BLoC has a non-null current path
  /// and emits [PageBlocPathChangedEvent] if so.
  @protected
  void emitPathChangedIfAny() {
    final currentPath = path;
    if (currentPath != null) {
      emitPathChanged();
    }
  }

  /// Emits [PageBlocPopEvent] for [PageStackBloc] to remove and dispose
  /// the current page. [data] is passed to the new topmost [PageBloc] and
  /// can be used as the modal dialog result.
  void pop([R? data]) {
    _eventsController.sink.add(
      PageBlocPopEvent<R>(
        data: data,
        cause: PopCause.pageBloc,
      ),
    );
  }

  /// Emits [PageBlocCloseEvent] for [PageStackBloc] to remove and dispose
  /// the current page.
  @Deprecated('Use pop')
  @nonVirtual
  void closeScreen() {
    _eventsController.sink.add(
      PageBlocPopEvent<R>(
        data: null,
        cause: PopCause.pageBloc,
      ),
    );
  }

  /// Emits [event] for [PageStackBloc] to remove and dispose the current page.
  /// [event] is passed to the new topmost [PageBloc] and can be used
  /// as modal dialog result.
  @Deprecated('Use pop for PageBlocCloseEvent or emitEvent for custom events')
  @nonVirtual
  void closeScreenWith(PageBlocPopEvent event) {
    _eventsController.sink.add(event);
  }

  /// Override this to use the result of a closed modal screen.
  void didPopNext(AbstractPage page, PageBlocPopEvent event) {}

  /// Override this to use the result of a closed modal screen.
  @Deprecated('Use didPopNext')
  @nonVirtual
  void onForegroundClosed(PageBlocPopEvent event) {}

  /// Called when Android back button is pressed with this page active.
  ///
  /// Override this to handle the event and to prevent the screen from closing.
  /// The closing itself is done in [PageStackNavigator] so this method
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

typedef PageBloc<R> = CPageBloc<PagePath, R>;
