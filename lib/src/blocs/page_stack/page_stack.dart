import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

import 'event.dart';
import 'screen_bloc_normalized_state.dart';
import 'screen_event.dart';
import 'page_stack_bloc_normalized_state.dart';
import '../screen/close_event.dart';
import '../screen/configuration_changed_event.dart';
import '../screen/event.dart';
import '../../pages/abstract.dart';

/// The source of pages for [Navigator] widget.
///
/// [C] is the base class for all app's page configurations.
class PageStackBloc<C> {
  final _pages = <AbstractPage<C>>[];
  List<AbstractPage<C>> get pages => _pages;

  /// A factory to create pages from their serialized states.
  final AbstractPage<C>? Function(String key, Map<String, dynamic> state)? createPage;
  final DuplicatePageKeyAction duplicatePageKeyAction;

  final _eventsController = BehaviorSubject<PageStackBlocEvent>();
  Stream<PageStackBlocEvent> get events => _eventsController.stream;

  PageStackBloc({
    required AbstractPage<C> bottomPage,
    this.createPage,
    this.duplicatePageKeyAction = DuplicatePageKeyAction.bringOld,
  }) {
    _pushNoFire(bottomPage);
  }

  /// The first non-null page currentConfiguration from top.
  C get topPageCurrentConfiguration {
    for (final page in _pages.reversed) {
      final configuration = page.currentConfiguration;
      if (configuration != null) return configuration;
    }

    throw Exception('No configuration found for this stack.');
  }

  /// Pushes a page to the stack much like [Navigator.push] does.
  void push(AbstractPage<C> page) {
    _pushNoFire(page);
    _firePageConfigurationChange(page);
  }

  void _pushNoFire(AbstractPage<C> page) {
    final oldPage = _findSameKeyPage(page.key);
    if (oldPage == null) {
      _pushNewPageNoFire(page);
      return;
    }

    _pushDuplicateNoFire(oldPage, page);
  }

  AbstractPage<C>? _findSameKeyPage(LocalKey key) {
    return _pages.firstWhereOrNull((page) => page.key == key);
  }

  void _pushNewPageNoFire(AbstractPage<C> page) {
    _pages.add(page);

    final bloc = page.bloc;
    if (bloc != null) {
      bloc.events.listen((event) => _onPageEvent(page, event));
    }
  }

  void _onPageEvent(AbstractPage<C> page, ScreenBlocEvent event) {
    _emitPageEvent(page, event);

    if (event is ScreenBlocCloseEvent && _pages.length >= 2) {
      _pages.remove(page);
      _firePageConfigurationChange(_pages.last);
      _schedulePageDisposal(page);
    }
  }

  void _emitPageEvent(AbstractPage<C> page, ScreenBlocEvent event) {
    final pageStackEvent = PageStackScreenBlocEvent<C>(
      page: page,
      bloc: page.bloc,
      screenBlocEvent: event,
    );
    _eventsController.sink.add(pageStackEvent);
  }

  void _pushDuplicateNoFire(AbstractPage<C> oldPage, AbstractPage<C> newPage) {
    switch (duplicatePageKeyAction) {
      case DuplicatePageKeyAction.error:
        throw Exception('Duplicate page key: ${newPage.key}');

      case DuplicatePageKeyAction.dropOld:
        _pages.remove(oldPage);
        _pages.add(newPage);
        _schedulePageDisposal(oldPage);
        break;

      case DuplicatePageKeyAction.bringOld:
        newPage.dispose();
        _pages.remove(oldPage);
        _pages.add(oldPage);
        break;
    }
  }

  void _firePageConfigurationChange(AbstractPage<C> page) {
    _eventsController.sink.add(
      PageStackScreenBlocEvent(
        page: page,
        bloc: page.bloc,
        screenBlocEvent: ScreenBlocConfigurationChangedEvent(
          //configuration: page.currentConfiguration,
        ),
      ),
    );
  }

  /// Passes the back button event to the foreground page bloc.
  ///
  /// If that bloc handles the event itself, returns [true].
  ///
  /// If that bloc does not handle the event itself AND it is not the bottommost
  /// one, pops it and disposes the page, then returns [true].
  ///
  /// Otherwise returns [false]. This may signal to shut down the app
  /// or to close some widgets wrapping this stack.
  Future<bool> onBackPressed() async {
    final page = _pages.lastOrNull;
    if (page == null) return false; // Normally never happens.

    final bloc = page.bloc;
    if (bloc != null) {
      if (await bloc.onBackPressed()) {
        return true;
      }
    }

    // TODO: Check if pages changed while waiting.

    // _pages can never be empty. Only pop if there are at least 2.
    if (_pages.length >= 2) {
      _pages.removeLast();
      _firePageConfigurationChange(_pages.last);
      _schedulePageDisposal(page);
      return true;
    }

    return false;
  }

  /// Normalizes all pages' states serialization.
  PageStackBlocNormalizedState get normalizedState {
    return PageStackBlocNormalizedState(
      screenStates: _pages.map((p) => _getPageNormalizedState(p)).toList(growable: false),
    );
  }

  ScreenBlocNormalizedState _getPageNormalizedState(AbstractPage<C> page) {
    return ScreenBlocNormalizedState(
      pageKey: page.key.toString(),
      state: page.bloc?.normalizedState ?? const <String, dynamic>{},
    );
  }

  /// Recovers pages and their states.
  ///
  /// 1. Compares the current stack with given page states from bottom to top.
  ///    For each page with key matching state's pageKey, recovers its state.
  ///
  /// 2. When a mismatch is found, pops and disposes the remaining pages.
  ///    This goes from top to bottom.
  ///
  /// 3. For page states that were not matched, creates the pages
  ///    with [createPage] factory and sets their states.
  ///    Stops at the first page that failed to be created.
  set normalizedState(PageStackBlocNormalizedState state) {
    int matchedIndex = 0;
    int matchLength = min(_pages.length, state.screenStates.length);

    for (; matchedIndex < matchLength; matchedIndex++) {
      final page = _pages[matchedIndex];
      final screenState = state.screenStates[matchedIndex];

      if (page.key.value != screenState.pageKey) break;
      page.bloc?.normalizedState = screenState.state;
    }

    for (int i = _pages.length; --i >= matchedIndex; ) {
      final page = _pages.removeAt(i);
      _schedulePageDisposal(page);
    }

    for (int i = matchedIndex; i < state.screenStates.length; i++) {
      if (!_createPage(state.screenStates[i])) break;
    }

    _firePageConfigurationChange(_pages.last);
  }

  bool _createPage(ScreenBlocNormalizedState state) {
    if (createPage == null) return false;

    final page = createPage!(state.pageKey, state.state);
    if (page == null) return false;

    page.bloc?.normalizedState = state.state;
    _pushNoFire(page);
    return true;
  }

  void _schedulePageDisposal(AbstractPage<C> page) async {
    // If we dispose the page immediately (or even with 1 frame delay of
    // Future.delayed(Duration.zero), the bloc will dispose
    // TextEditingController objects, and we get the exception of using disposed
    // controllers before the screen is gone.
    // TODO: Find a guaranteed synchronous way.
    await Future.delayed(const Duration(seconds: 10));
    page.dispose();
  }

  void dispose() {
    for (final page in _pages) {
      page.dispose();
    }

    _eventsController.close();
  }
}

/// What to do if pushing a page with a key already existing in the stack.
enum DuplicatePageKeyAction {
  /// Remove and dispose the old page, create a new one on top.
  dropOld,

  /// Dispose the new page without adding, bring the old page to the top.
  bringOld,

  /// Throw an exception.
  error,
}
