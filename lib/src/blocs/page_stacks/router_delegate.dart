import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

abstract class PageStacksRouterDelegate extends RouterDelegate<PageStacksConfiguration> with ChangeNotifier, PopNavigatorRouterDelegateMixin<PageStacksConfiguration> {
  @override
  final navigatorKey = GlobalKey<NavigatorState>();
  final PageStacksBloc pageStacksBloc;

  PageStacksRouterDelegate(this.pageStacksBloc) {
    // TODO: Filter events, do not fire on all.
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
