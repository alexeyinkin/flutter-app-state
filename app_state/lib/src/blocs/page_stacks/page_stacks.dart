import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

import '../page_stack/event.dart';
import '../page_stack/page_stack.dart';
import 'configuration.dart';
import 'configuration_changed_event.dart';
import 'current_page_stack_changed_event.dart';
import 'event.dart';
import 'page_stack_event.dart';

/// A container for [PageStack] objects with a concept of a current one.
///
/// Suitable for implementing tabs with a separate navigation stack in each one.
class PageStacks {
  final _pageStacks = <String, PageStack>{};
  String? _currentStackKey;

  final _eventsController = BehaviorSubject<PageStacksEvent>();

  Stream<PageStacksEvent> get events => _eventsController.stream;

  void addPageStack(String key, PageStack stack) {
    _pageStacks[key] = stack;
    stack.events.listen((e) => _onPageStackEvent(stack, e));
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

    if (fire) {
      _eventsController.add(const PageStacksConfigurationChangedEvent());
    }
  }

  String? get currentStackKey => _currentStackKey;

  void setCurrentStackKey(String? key, {bool fire = true}) {
    if (_currentStackKey == key) {
      return;
    }

    final oldKey = _currentStackKey;
    _currentStackKey = key;

    if (fire) {
      _eventsController.add(
        CurrentPageStackChangedEvent(oldKey: oldKey, newKey: key),
      );
    }
  }

  void _onPageStackEvent(PageStack stack, PageStackEvent event) {
    _eventsController.add(
      PageStacksStackEvent(
        stack: stack,
        pageStackEvent: event,
      ),
    );
  }

  // ignore: deprecated_member_use_from_same_package
  PageStack? get currentStack => currentStackBloc;

  @Deprecated('Renamed to currentStack in v0.7.0')
  PageStack? get currentStackBloc => _pageStacks[_currentStackKey];

  UnmodifiableMapView<String, PageStack> get pageStacks {
    return UnmodifiableMapView(_pageStacks);
  }
}

@Deprecated('Renamed to PageStacks in v0.7.0')
typedef PageStacksBloc = PageStacks;
