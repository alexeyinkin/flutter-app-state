import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

import 'configuration.dart';
import 'current_page_stack_changed_event.dart';
import 'event.dart';
import 'page_stack_event.dart';
import '../page_stack/bloc.dart';
import '../page_stack/event.dart';

/// A container for [PageStackBloc] objects with a concept of a current one.
///
/// Suitable for implementing tabs with a separate navigation stack in each one.
class PageStacksBloc {
  final _pageStacks = <String, PageStackBloc>{};
  String? _currentStackKey;

  final _eventsController = BehaviorSubject<PageStacksBlocEvent>();

  Stream<PageStacksBlocEvent> get events => _eventsController.stream;

  void addPageStack(String key, PageStackBloc bloc) {
    _pageStacks[key] = bloc;
    bloc.events.listen((e) => _onPageStackEvent(bloc, e));
  }

  PageStacksConfiguration getConfiguration() {
    return PageStacksConfiguration(
      pageStackConfigurations: _pageStacks.map(
        (key, pageStackBloc) => MapEntry(key, pageStackBloc.getConfiguration()),
      ),
      currentStackKey: _currentStackKey,
    );
  }

  void setConfiguration(PageStacksConfiguration state, {bool fire = true}) {
    for (final entry in state.pageStackConfigurations.entries) {
      _pageStacks[entry.key]?.setConfiguration(entry.value, fire: fire);
    }

    setCurrentStackKey(state.currentStackKey, fire: fire);
  }

  String? get currentStackKey => _currentStackKey;

  void setCurrentStackKey(String? key, {bool fire = true}) {
    if (_currentStackKey == key) return;

    final oldKey = _currentStackKey;
    _currentStackKey = key;

    if (fire) {
      _eventsController.add(
        CurrentPageStackChangedEvent(oldKey: oldKey, newKey: key),
      );
    }
  }

  void _onPageStackEvent(PageStackBloc bloc, PageStackBlocEvent event) {
    _eventsController.add(
      PageStacksPageStackBlocEvent(
        bloc: bloc,
        pageStackBlocEvent: event,
      ),
    );
  }

  PageStackBloc? get currentStackBloc => _pageStacks[_currentStackKey];

  UnmodifiableMapView<String, PageStackBloc> get pageStacks {
    return UnmodifiableMapView(_pageStacks);
  }
}
