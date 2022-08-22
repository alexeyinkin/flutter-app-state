import 'package:flutter/widgets.dart';

import '../../widgets/navigator.dart';
import '../page/path_changed_event.dart';
import 'configuration.dart';
import 'event.dart';
import 'page_event.dart';
import 'page_stack.dart';

class PageStackRouterDelegate extends RouterDelegate<PageStackConfiguration>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<PageStackConfiguration> {
  final List<NavigatorObserver> observers;
  final PageStack pageStack;
  final TransitionDelegate<dynamic> transitionDelegate;

  @Deprecated('Renamed to pageStack in v0.7.0')
  PageStack get pageStackBloc => pageStack;

  PageStackRouterDelegate(
    this.pageStack, {
    this.observers = const <NavigatorObserver>[],
    this.transitionDelegate = const DefaultTransitionDelegate<dynamic>(),
  }) {
    pageStack.events.listen(_onPageStackEvent);
  }

  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  PageStackConfiguration? get currentConfiguration {
    return pageStack.getConfiguration();
  }

  @override
  Widget build(BuildContext context) {
    return PageStackNavigator(
      stack: pageStack,
      observers: observers,
      transitionDelegate: transitionDelegate,
    );
  }

  @override
  Future<void> setNewRoutePath(PageStackConfiguration configuration) async {
    return pageStack.setConfiguration(configuration);
  }

  void _onPageStackEvent(PageStackEvent event) {
    if (event is PageStackPageEvent) {
      if (event.pageEvent is PagePathChangedEvent) {
        notifyListeners();
      }
    }
  }
}
