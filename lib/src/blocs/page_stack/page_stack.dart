import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

import 'event.dart';
import 'screen_event.dart';
import '../screen/close_event.dart';
import '../screen/configuration_changed_event.dart';
import '../screen/event.dart';
import '../../pages/abstract.dart';

class PageStackBloc<C> {
  final _pages = <AbstractPage<C>>[];
  List<AbstractPage<C>> get pages => _pages;

  final DuplicatePageKeyAction duplicatePageKeyAction;

  final _eventsController = BehaviorSubject<PageStackBlocEvent>();
  Stream<PageStackBlocEvent> get events => _eventsController.stream;

  PageStackBloc({
    required AbstractPage<C> bottomPage,
    this.duplicatePageKeyAction = DuplicatePageKeyAction.bringOld,
  }) {
    _pushPageNoFire(bottomPage);
  }

  C get currentConfiguration {
    for (final page in _pages.reversed) {
      final configuration = page.currentConfiguration;
      if (configuration != null) return configuration;
    }

    throw Exception('No configuration found for this stack.');
  }

  void pushPage(AbstractPage<C> page) {
    _pushPageNoFire(page);
    _firePageConfigurationChange(page);
  }

  void _pushPageNoFire(AbstractPage<C> page) {
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

    _pushDuplicatePageNoFire(oldPage, page);
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

  void _pushDuplicatePageNoFire(AbstractPage<C> oldPage, AbstractPage<C> newPage) {
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
          configuration: page.currentConfiguration,
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

enum DuplicatePageKeyAction {
  dropOld,
  bringOld,
  error,
}
