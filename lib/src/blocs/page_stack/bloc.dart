import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/back_pressed_result_enum.dart';
import '../../pages/abstract.dart';
import '../../util/util.dart';
import '../page/event.dart';
import '../page/path.dart';
import '../page/path_changed_event.dart';
import '../page/pop_cause.dart';
import '../page/pop_event.dart';
import 'configuration.dart';
import 'configuration_setters/abstract.dart';
import 'configuration_setters/key_or_null_path_no_gap.dart';
import 'configuration_setters/none.dart';
import 'duplicate_page_key_action.dart';
import 'event.dart';
import 'match_mode.dart';
import 'page_event.dart';
import 'page_factory_function.dart';
import 'route_information_parser.dart';

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
  final CPageFactoryFunction<P>? createPage;

  /// What to do if pushing a page with a key already existing in the stack.
  final DuplicatePageKeyAction onDuplicateKey;

  /// Allows declarative navigation with [replacePath] if set.
  final PageStackRouteInformationParser? routeInformationParser;

  final _eventsController = BehaviorSubject<PageStackBlocEvent>();

  Stream<PageStackBlocEvent> get events => _eventsController.stream;

  CPageStackBloc({
    required CAbstractPage<P, dynamic> bottomPage,
    this.createPage,
    this.onDuplicateKey = DuplicatePageKeyAction.bringOld,
    this.routeInformationParser,
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

    if (event is PageBlocPopEvent) {
      final index = _pages.indexOf(page);

      if (index > 0) {
        _pages.removeAt(index);
        final pageBelow = _pages[index - 1];

        handleRemoved(pageBelow, page, event);

        // Even if the top page stayed the same, fire its change
        // because it may want to store the whole stack config.
        _firePathChange(_pages.last);
      }
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

  /// Called when a page is removed from the stack for any reason.
  ///
  /// Reasons are limited to:
  /// 1. The back button was pressed, and the bloc did not prevent the pop.
  /// 2. The configuration setter removed it from the stack while applying
  ///    a stack configuration.
  /// 3. The bloc emitted the [event] to pop.
  ///
  /// This does:
  /// 1. Complete the page future.
  /// 2. Call didPopNext and onForegroundClosed on a bloc below.
  /// 3. Schedule the page disposal.
  @visibleForTesting
  void handleRemoved<R>(
    CAbstractPage<P, dynamic>? pageBelow,
    CAbstractPage<P, R> page,
    PageBlocPopEvent<R> event,
  ) {
    page.completer.complete(event.data);
    pageBelow?.bloc?.didPopNext(page, event);
    _schedulePageDisposal(page);

    // ignore: deprecated_member_use_from_same_package
    pageBelow?.bloc?.onForegroundClosed(event);
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
    final oldPages = [..._pages];
    final page = oldPages.lastOrNull;
    if (page == null) {
      return BackPressedResult.close; // Normally never happens.
    }

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

      handleRemoved(
        oldPages.elementAtOrNull(oldPages.length - 2),
        page,
        page.createPopEvent(data: null, cause: PopCause.backButton),
      );

      _firePathChange(_pages.last);
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
    PageStackMatchMode mode = PageStackMatchMode.keyOrNullPathNoGap,
    @internal CAbstractPageStackConfigurationSetter? setter,
    bool fire = true,
  }) {
    final useSetter = setter ?? _getConfigurationSetter(mode);
    final oldPages = [..._pages];

    useSetter.set(
      pages: _pages,
      configuration: configuration,
      createAndPushPage: _createAndPushPage,
    );

    if (_pages.isEmpty) {
      _pages.addAll(oldPages);

      throw Exception(
        'PageStackBloc was about to be emptied by setting '
        'a configuration state. '
        'The stack should never be empty according to the Navigator API.',
      );
    }

    final newPageSet = {for (final page in _pages) page};

    for (int i = oldPages.length; --i >= 0;) {
      final page = oldPages[i];

      if (newPageSet.contains(page)) {
        continue;
      }

      handleRemoved(
        oldPages.elementAtOrNull(i - 1),
        page,
        page.createPopEvent(data: null, cause: PopCause.diff),
      );
    }
  }

  void _createAndPushPage(PagePath path) {
    final page = _createPage(path);

    if (page == null) {
      // But if we cannot create a page with path, it is not OK.
      // A path implies recoverability.
      // Also consider throwing Exception in createPage factory on failure
      // so we will not get here.
      return;
    }

    _pushNoFire(page, onDuplicateKey);
  }

  CAbstractPage<P, dynamic>? _createPage(PagePath path) {
    if (createPage == null || path.factoryKey == null) {
      return null;
    }

    final page = createPage!(path.factoryKey!, path.state);
    if (page == null) {
      return null;
    }

    page.bloc?.setStateMap(path.state);
    return page;
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

  /// Replaces the stack of pages with the full default stack parsed
  /// from [path] (declarative navigation).
  ///
  /// Requires [routeInformationParser] to be non-null.
  Future<void> replacePath(
    P path, {
    PageStackMatchMode mode = PageStackMatchMode.keyOrNullPathNoGap,
  }) async {
    final ri = RouteInformation(
      location: path.location,
      state: path.state,
    );

    final configuration =
        await routeInformationParser?.parsePageStackConfiguration(ri);

    if (configuration == null) {
      throw Exception('This requires routeInformationParser');
    }

    setConfiguration(configuration, setter: _getConfigurationSetter(mode));
  }

  CAbstractPageStackConfigurationSetter _getConfigurationSetter(
    PageStackMatchMode mode,
  ) {
    switch (mode) {
      case PageStackMatchMode.none:
        return CNonePageStackConfigurationSetter<P>();
      case PageStackMatchMode.keyOrNullPathNoGap:
        return CKeyOrNullPathNoGapPageStackConfigurationSetter<P>();
    }
  }

  void dispose() {
    for (final page in _pages) {
      page.dispose();
    }

    _eventsController.close();
  }
}

typedef PageStackBloc = CPageStackBloc<PagePath>;
