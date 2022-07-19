import 'package:flutter/widgets.dart';

import 'bloc.dart';
import 'configuration.dart';

abstract class PageStacksRouterDelegate
    extends RouterDelegate<PageStacksConfiguration>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<PageStacksConfiguration> {
  @override
  final navigatorKey = GlobalKey<NavigatorState>();
  final PageStacksBloc pageStacksBloc;

  PageStacksRouterDelegate(this.pageStacksBloc) {
    // TODO(alexeyinkin): Filter events, do not fire on all,
    //  https://github.com/alexeyinkin/flutter-app-state/issues/6
    pageStacksBloc.events.listen((e) => notifyListeners());
  }

  @override
  PageStacksConfiguration? get currentConfiguration {
    return pageStacksBloc.getConfiguration();
  }

  @override
  Future<void> setNewRoutePath(PageStacksConfiguration configuration) async {
    return pageStacksBloc.setConfiguration(configuration);
  }
}
