import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

import 'duplicate_page_key_action.dart';
import 'event.dart';
import 'page_event.dart';
import 'configuration.dart';
import '../page/configuration.dart';
import '../page/close_event.dart';
import '../page/configuration_changed_event.dart';
import '../page/event.dart';
import '../../models/back_pressed_result_enum.dart';
import '../../pages/abstract.dart';

/// The source of pages for [Navigator] widget.
///
/// [C] is the base class for all app's page configurations.
class PageStackBloc<C extends PageConfiguration> {
  final _pages = <AbstractPage<C>>[];

  List<AbstractPage<C>> get pages => _pages;

  /// A factory to create pages from their serialized states.
  /// It is called when a popped page should be re-created on back-forward
  /// navigation. If null, pages will not be re-created this way.
  /// This makes navigation useless except for popping.
  final AbstractPage<C>? Function(
    String factoryKey,
    Map<String, dynamic> state,
  )? createPage;

  /// What to do if pushing a page with a key already existing in the stack.
  final DuplicatePageKeyAction onDuplicateKey;

  final _eventsController = BehaviorSubject<PageStackBlocEvent>();

  Stream<PageStackBlocEvent> get events => _eventsController.stream;

  PageStackBloc({
    required AbstractPage<C> bottomPage,
    this.createPage,
    this.onDuplicateKey = DuplicatePageKeyAction.bringOld,
  }) {
    _pushNoFire(bottomPage, onDuplicateKey);
  }

  /// The first non-null page configuration from top.
  C getTopPageConfiguration() {
    for (final page in _pages.reversed) {
      final configuration = page.getConfiguration();
      if (configuration != null) return configuration;
    }

    throw Exception('No configuration found for this stack.');
  }

  /// Pushes a page to the stack much like [Navigator.push] does.
  void push(
    AbstractPage<C> page, {
    DuplicatePageKeyAction? onDuplicateKey,
  }) {
    _pushNoFire(page, onDuplicateKey ?? this.onDuplicateKey);
    _firePageConfigurationChange(page);
  }

  void _pushNoFire(
    AbstractPage<C> page,
    DuplicatePageKeyAction duplicatePageKeyAction,
  ) {
    final key = page.key;
    if (key == null) {
      _pushNewPageNoFire(page);
      return;
    }

    final oldPage = _findSameKeyPage(key);
    if (oldPage == null) {
      _pushNewPageNoFire(page);
      return;
    }

    _pushDuplicateNoFire(oldPage, page, duplicatePageKeyAction);
  }

  AbstractPage<C>? _findSameKeyPage(ValueKey<String> key) {
    return _pages.firstWhereOrNull((page) => page.key == key);
  }

  void _pushNewPageNoFire(AbstractPage<C> page) {
    _pages.add(page);

    final bloc = page.bloc;
    if (bloc != null) {
      bloc.events.listen((event) => _onPageEvent(page, event));
    }
  }

  void _onPageEvent(AbstractPage<C> page, PageBlocEvent event) {
    _emitPageEvent(page, event);

    if (event is PageBlocCloseEvent && _pages.length >= 2) {
      _pages.remove(page);
      _firePageConfigurationChange(_pages.last);
      _schedulePageDisposal(page);

      final newTopBloc = _pages.last.bloc;
      newTopBloc?.onForegroundClosed(event);
    }
  }

  void _emitPageEvent(AbstractPage<C> page, PageBlocEvent event) {
    final pageStackEvent = PageStackPageBlocEvent<C>(
      page: page,
      bloc: page.bloc,
      pageBlocEvent: event,
    );
    _eventsController.sink.add(pageStackEvent);
  }

  void _pushDuplicateNoFire(
    AbstractPage<C> oldPage,
    AbstractPage<C> newPage,
    DuplicatePageKeyAction onDuplicateKey,
  ) {
    switch (onDuplicateKey) {
      case DuplicatePageKeyAction.error:
        throw Exception('Duplicate page key: ${newPage.key}');

      case DuplicatePageKeyAction.dropOld:
        _pages.remove(oldPage);
        _pages.add(newPage);
        _schedulePageDisposal(oldPage);
        return;

      case DuplicatePageKeyAction.bringOld:
        newPage.dispose();
        _pages.remove(oldPage);
        _pages.add(oldPage);
        return;
    }

    throw Exception('Unknown onDuplicateKey: $onDuplicateKey');
  }

  void _firePageConfigurationChange(AbstractPage<C> page) {
    _eventsController.sink.add(
      PageStackPageBlocEvent(
        page: page,
        bloc: page.bloc,
        pageBlocEvent: const PageBlocConfigurationChangedEvent(),
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
  Future<BackPressedResult> onBackPressed() async {
    final page = _pages.lastOrNull;
    if (page == null) return BackPressedResult.close; // Normally never happens.

    final bloc = page.bloc;
    if (bloc != null) {
      final result = await bloc.onBackPressed();
      if (result == BackPressedResult.keep) {
        return result;
      }
    }

    // TODO: Check if pages changed while waiting.

    // _pages can never be empty. Only pop if there are at least 2.
    if (_pages.length >= 2) {
      _pages.removeLast();
      _firePageConfigurationChange(_pages.last);
      _schedulePageDisposal(page);
      return BackPressedResult.keep;
    }

    return BackPressedResult.close;
  }

  /// Surveys all pages' configurations for serialization.
  PageStackConfiguration getConfiguration() {
    return PageStackConfiguration(
      pageConfigurations:
          _pages.map((p) => p.getConfiguration()).toList(growable: false),
    );
  }

  /// Recovers pages and their states.
  ///
  /// 1. Compares the current stack with given page states from bottom to top.
  ///    For each page with key matching configuration's key, recovers its
  ///    state.
  ///
  /// 2. When a mismatch is found, pops and disposes the remaining pages.
  ///    This goes from top to bottom.
  ///
  /// 3. For page states that were not matched, creates the pages
  ///    with [createPage] factory and sets their states.
  ///    Stops at the first page that failed to be created.
  void setConfiguration(PageStackConfiguration configuration,
      {bool fire = true}) {
    int matchedIndex = 0;
    int matchLength =
        min(_pages.length, configuration.pageConfigurations.length);

    for (; matchedIndex < matchLength; matchedIndex++) {
      final page = _pages[matchedIndex];
      final pc = configuration.pageConfigurations[matchedIndex];

      if (page.key == null && pc == null) {
        // A page without key is implied to be the same, and no state can
        // be applied to it.
        continue;
      }

      if (page.key?.value != pc?.key) break;

      if (pc != null) {
        page.bloc?.setStateMap(pc.state);
      }
    }

    for (int i = _pages.length; --i >= matchedIndex;) {
      final page = _pages.removeAt(i);
      _schedulePageDisposal(page);
    }

    for (int i = matchedIndex;
        i < configuration.pageConfigurations.length;
        i++) {
      final pc = configuration.pageConfigurations[i];
      if (pc == null) {
        // Pages without configuration are transient dialogs, these are OK
        // to skip. Otherwise we will never be able to recover good URLed pages
        // on top of transient dialogs.
        continue;
      }

      if (!_createPage(pc)) {
        // But if we cannot create a page with configuration, it is not OK.
        // Configuration implies recoverability.
        // Also consider throwing Exception in createPage factory on failure
        // so we will not get here.
        break;
      }
    }

    if (fire) _firePageConfigurationChange(_pages.last);

    // TODO: Prevent emptying. Maybe keep the list of popped pages
    //       and only dispose them when we determine the stack is not emptied.
    if (_pages.isEmpty) {
      throw Exception(
        'PageStackBloc is emptied by setting a configuration state. '
        'The stack should never be empty according to the Navigator API.',
      );
    }
  }

  bool _createPage(PageConfiguration pc) {
    if (createPage == null || pc.factoryKey == null) return false;

    final page = createPage!(pc.factoryKey!, pc.state);
    if (page == null) return false;

    page.bloc?.setStateMap(pc.state);
    _pushNoFire(page, onDuplicateKey);
    return true;
  }

  void _schedulePageDisposal(AbstractPage<C> page) async {
    // If we dispose the page immediately (or even with 1 frame delay of
    // Future.delayed(Duration.zero)), the bloc will dispose
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
