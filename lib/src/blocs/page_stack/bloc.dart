import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/back_pressed_result_enum.dart';
import '../../pages/abstract.dart';
import '../page/close_event.dart';
import '../page/event.dart';
import '../page/path.dart';
import '../page/path_changed_event.dart';
import 'configuration.dart';
import 'duplicate_page_key_action.dart';
import 'event.dart';
import 'page_event.dart';

/// The source of pages for [Navigator] widget.
///
/// [P] is the base class for all app's page paths.
class CPageStackBloc<P extends PagePath> {
  final _pages = <CAbstractPage<P, dynamic>>[];

  List<CAbstractPage<P, dynamic>> get pages => _pages;

  /// A factory to create pages from their serialized states.
  /// It is called when a popped page should be re-created on back-forward
  /// navigation. If null, pages will not be re-created this way.
  /// This makes navigation useless except for popping.
  final CAbstractPage<P, dynamic>? Function(
    String factoryKey,
    Map<String, dynamic> state,
  )? createPage;

  /// What to do if pushing a page with a key already existing in the stack.
  final DuplicatePageKeyAction onDuplicateKey;

  final _eventsController = BehaviorSubject<PageStackBlocEvent>();

  Stream<PageStackBlocEvent> get events => _eventsController.stream;

  CPageStackBloc({
    required CAbstractPage<P, dynamic> bottomPage,
    this.createPage,
    this.onDuplicateKey = DuplicatePageKeyAction.bringOld,
  }) {
    _pushNoFire(bottomPage, onDuplicateKey);
  }

  /// The first non-null page path from top.
  P getTopPagePath() {
    for (final page in _pages.reversed) {
      final path = page.path;

      if (path != null) {
        return path;
      }
    }

    throw Exception('No path found for this stack.');
  }

  /// Pushes a page to the stack much like [Navigator.push] does.
  Future<R?> push<R>(
    CAbstractPage<P, R> page, {
    DuplicatePageKeyAction? onDuplicateKey,
  }) {
    final future = _pushNoFire<R>(page, onDuplicateKey ?? this.onDuplicateKey);
    _firePathChange<R>(page);
    return future;
  }

  Future<R?> _pushNoFire<R>(
    CAbstractPage<P, R> page,
    DuplicatePageKeyAction duplicatePageKeyAction,
  ) {
    final key = page.key;
    if (key == null) {
      _pushNewPageNoFire(page);
      return page.completer.future;
    }

    final oldPage = _findSameKeyPage<R>(key);
    if (oldPage == null) {
      _pushNewPageNoFire(page);
      return page.completer.future;
    }

    return _pushDuplicateNoFire(oldPage, page, duplicatePageKeyAction);
  }

  CAbstractPage<P, R>? _findSameKeyPage<R>(ValueKey<String> key) {
    return _pages.firstWhereOrNull((page) => page.key == key)
        as CAbstractPage<P, R>?;
  }

  Future<R?> _pushNewPageNoFire<R>(CAbstractPage<P, R> page) {
    _pages.add(page);

    final bloc = page.bloc;
    if (bloc != null) {
      bloc.events.listen((event) => _onPageEvent<R>(page, event));
    }

    return page.completer.future;
  }

  void _onPageEvent<R>(CAbstractPage<P, R> page, PageBlocEvent event) {
    _emitPageEvent(page, event);

    if (event is PageBlocCloseEvent && _pages.length >= 2) {
      _pages.remove(page);
      _firePathChange(_pages.last);

      final newTopBloc = _pages.last.bloc;
      newTopBloc?.didPopNext(page, event);

      // ignore: deprecated_member_use_from_same_package
      newTopBloc?.onForegroundClosed(event);
      page.completer.complete(event.data);

      _schedulePageDisposal<R>(page);
    }
  }

  void _emitPageEvent<R>(CAbstractPage<P, R> page, PageBlocEvent event) {
    final pageStackEvent = CPageStackPageBlocEvent<P, R>(
      page: page,
      bloc: page.bloc,
      pageBlocEvent: event,
    );
    _eventsController.sink.add(pageStackEvent);
  }

  Future<R?> _pushDuplicateNoFire<R>(
    CAbstractPage<P, R> oldPage,
    CAbstractPage<P, R> newPage,
    DuplicatePageKeyAction onDuplicateKey,
  ) {
    switch (onDuplicateKey) {
      case DuplicatePageKeyAction.error:
        throw Exception('Duplicate page key: ${newPage.key}');

      case DuplicatePageKeyAction.dropOld:
        _pages.remove(oldPage);
        _pages.add(newPage);
        _schedulePageDisposal<R>(oldPage);
        oldPage.completer.complete(newPage.completer.future);
        return newPage.completer.future;

      case DuplicatePageKeyAction.bringOld:
        newPage.dispose();
        _pages.remove(oldPage);
        _pages.add(oldPage);
        return oldPage.completer.future;
    }
  }

  void _firePathChange<R>(CAbstractPage<P, R> page) {
    _eventsController.sink.add(
      PageStackPageBlocEvent(
        page: page,
        bloc: page.bloc,
        pageBlocEvent: const PageBlocPathChangedEvent(),
      ),
    );
  }

  /// Passes the back button event to the foreground page bloc.
  ///
  /// If that bloc handles the event itself, returns `true`.
  ///
  /// If that bloc does not handle the event itself AND it is not the bottommost
  /// one, pops it and disposes the page, then returns `true`.
  ///
  /// Otherwise returns `false`. This may signal to shut down the app
  /// or to close some widgets wrapping this stack.
  Future<BackPressedResult> onBackPressed() async {
    final page = _pages.lastOrNull;
    if (page == null) {
      return BackPressedResult.close;
    } // Normally never happens.

    final bloc = page.bloc;
    if (bloc != null) {
      final result = await bloc.onBackPressed();
      if (result == BackPressedResult.keep) {
        return result;
      }
    }

    // TODO(alexeyinkin): Check if pages changed while waiting, https://github.com/alexeyinkin/flutter-app-state/issues/2.

    // _pages can never be empty. Only pop if there are at least 2.
    if (_pages.length >= 2) {
      _pages.removeLast();
      _firePathChange(_pages.last);
      unawaited(_schedulePageDisposal(page));
      return BackPressedResult.keep;
    }

    return BackPressedResult.close;
  }

  /// Surveys all pages' paths for serialization.
  PageStackConfiguration getConfiguration() {
    return PageStackConfiguration(
      paths: _pages.map((p) => p.path).toList(growable: false),
    );
  }

  /// Recovers pages and their states.
  ///
  /// 1. Compares the current stack with given page states from bottom to top.
  ///    For each page with key matching the path's key, recovers its
  ///    state.
  ///
  /// 2. When a mismatch is found, pops and disposes the remaining pages.
  ///    This goes from top to bottom.
  ///
  /// 3. For page states that were not matched, creates the pages
  ///    with [createPage] factory and sets their states.
  ///    Stops at the first page that failed to be created.
  void setConfiguration(
    PageStackConfiguration configuration, {
    bool fire = true,
  }) {
    int matchedIndex = 0;
    final matchLength = min(
      _pages.length,
      configuration.paths.length,
    );

    for (; matchedIndex < matchLength; matchedIndex++) {
      final page = _pages[matchedIndex];
      final path = configuration.paths[matchedIndex];

      if (path == null) {
        // A null PagePath is implied to match any page,
        // and it cannot apply any state to it.
        // The only production case for it is non-web where this diff
        // only happens at startup and does nothing.
        continue;
      }

      if (page.key?.value != path.key) {
        break; // Mismatch. Will dispose this page and above.
      }

      page.bloc?.setStateMap(path.state);
    }

    for (int i = _pages.length; --i >= matchedIndex;) {
      final page = _pages.removeAt(i);
      page.completer.complete(null);
      _schedulePageDisposal(page);
    }

    for (int i = matchedIndex; i < configuration.paths.length; i++) {
      final path = configuration.paths[i];
      if (path == null) {
        // Pages without path are transient dialogs, these are OK
        // to skip. Otherwise we will never be able to recover good URLed pages
        // on top of transient dialogs.
        continue;
      }

      if (!_createPage(path)) {
        // But if we cannot create a page with path, it is not OK.
        // A path implies recoverability.
        // Also consider throwing Exception in createPage factory on failure
        // so we will not get here.
        break;
      }
    }

    if (fire) {
      _firePathChange(_pages.last);
    }

    // TODO(alexeyinkin): Prevent emptying. Maybe keep the list of popped pages, https://github.com/alexeyinkin/flutter-app-state/issues/3
    //       and only dispose them when we determine the stack is not emptied.
    if (_pages.isEmpty) {
      throw Exception(
        'PageStackBloc is emptied by setting a configuration state. '
        'The stack should never be empty according to the Navigator API.',
      );
    }
  }

  bool _createPage(PagePath path) {
    if (createPage == null || path.factoryKey == null) {
      return false;
    }

    final page = createPage!(path.factoryKey!, path.state);
    if (page == null) {
      return false;
    }

    page.bloc?.setStateMap(path.state);
    _pushNoFire(page, onDuplicateKey);
    return true;
  }

  Future<void> _schedulePageDisposal<R>(CAbstractPage<P, R> page) async {
    // If we dispose the page immediately (or even with 1 frame delay of
    // Future.delayed(Duration.zero)), the bloc will dispose
    // TextEditingController objects, and we get the exception of using disposed
    // controllers before the screen is gone.
    // TODO(alexeyinkin): Find a guaranteed synchronous way, https://github.com/alexeyinkin/flutter-app-state/issues/4
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

typedef PageStackBloc = CPageStackBloc<PagePath>;
