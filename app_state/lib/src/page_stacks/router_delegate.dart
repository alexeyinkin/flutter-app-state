import 'package:flutter/widgets.dart';

import 'configuration.dart';
import 'page_stacks.dart';

class PageStacksRouterDelegate extends RouterDelegate<PageStacksConfiguration>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<PageStacksConfiguration> {
  @override
  final navigatorKey = GlobalKey<NavigatorState>();
  final PageStacks pageStacks;
  final Widget child;

  PageStacksRouterDelegate(this.pageStacks, {required this.child}) {
    // TODO(alexeyinkin): Filter events, do not fire on all,
    //  https://github.com/alexeyinkin/flutter-app-state/issues/6
    pageStacks.events.listen((e) => notifyListeners());
  }

  @override
  PageStacksConfiguration? get currentConfiguration {
    return pageStacks.getConfiguration();
  }

  @override
  Future<void> setNewRoutePath(PageStacksConfiguration configuration) async {
    return pageStacks.setConfiguration(configuration);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        _ChildPage(
          key: const ValueKey('PageStacksRouterDelegate'),
          child: child,
        ),
      ],
      onDidRemovePage: (page) {
        // Never get here.
      },
    );
  }
}

class _ChildPage extends Page<void> {
  final Widget child;

  const _ChildPage({
    required super.key,
    required this.child,
  });

  @override
  Route<void> createRoute(BuildContext context) {
    return PageRouteBuilder<void>(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
    );
  }
}

@Deprecated('Use PageStacksRouterDelegate')
typedef MaterialPageStacksRouterDelegate = PageStacksRouterDelegate;
