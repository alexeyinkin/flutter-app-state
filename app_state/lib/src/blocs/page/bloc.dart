import 'package:meta/meta.dart';

import '../page_stack/page_stack.dart';
import 'page_state_mixin.dart';
import 'path.dart';
import 'pop_event.dart';

/// A BLoC that backs each stateful page of your app.
///
/// [P] is the base class for all app's paths.
/// [R] is the result returned when the page pops.
@Deprecated('Use PPageStateMixin')
class CPageBloc<P extends PagePath, R> with PPageStateMixin<P, R> {
  @override
  P? get path =>
      getConfiguration(); // ignore: deprecated_member_use_from_same_package

  @Deprecated('Use "path" getter. See CHANGELOG for v0.6.2')
  @nonVirtual
  P? getConfiguration() => super.path;

  @override
  @protected
  void emitPathChanged() =>
      emitConfigurationChanged(); // ignore: deprecated_member_use_from_same_package

  @protected
  @Deprecated('Renamed to emitPathChanged, see CHANGELOG for v0.6.2')
  @nonVirtual
  void emitConfigurationChanged() {
    super.emitPathChanged();
  }

  /// Emits [PageBlocCloseEvent] for [PageStackBloc] to remove and dispose
  /// the current page.
  @Deprecated('Use pop')
  @nonVirtual
  void closeScreen() {
    super.pop();
  }

  /// Emits [event] for [PageStackBloc] to remove and dispose the current page.
  /// [event] is passed to the new topmost [PageBloc] and can be used
  /// as modal dialog result.
  @Deprecated('Use pop for PageBlocCloseEvent or emitEvent for custom events')
  @nonVirtual
  void closeScreenWith(PageBlocPopEvent event) {
    super.emitEvent(event);
  }

  /// Override this to use the result of a closed modal screen.
  @Deprecated('Use didPopNext')
  @nonVirtual
  void onForegroundClosed(PageBlocPopEvent event) {}
}

@Deprecated('Use PageStateMixin')
// ignore: deprecated_member_use_from_same_package
typedef PageBloc<R> = CPageBloc<PagePath, R>;
