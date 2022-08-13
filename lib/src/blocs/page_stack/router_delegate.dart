import 'package:flutter/widgets.dart';

import '../../widgets/navigator.dart';
import '../page/path_changed_event.dart';
import 'bloc.dart';
import 'configuration.dart';
import 'event.dart';
import 'page_event.dart';

class PageStackRouterDelegate extends RouterDelegate<PageStackConfiguration>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<PageStackConfiguration> {
  final List<NavigatorObserver> observers;
  final PageStackBloc pageStackBloc;
  final TransitionDelegate<dynamic> transitionDelegate;

  PageStackRouterDelegate(
    this.pageStackBloc, {
    this.observers = const <NavigatorObserver>[],
    this.transitionDelegate = const DefaultTransitionDelegate<dynamic>(),
  }) {
    pageStackBloc.events.listen(_onPageStackEvent);
  }

  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  PageStackConfiguration? get currentConfiguration {
    return pageStackBloc.getConfiguration();
  }

  @override
  Widget build(BuildContext context) {
    return PageStackNavigator(
      bloc: pageStackBloc,
      observers: observers,
      transitionDelegate: transitionDelegate,
    );
  }

  @override
  Future<void> setNewRoutePath(PageStackConfiguration configuration) async {
    return pageStackBloc.setConfiguration(configuration);
  }

  void _onPageStackEvent(PageStackBlocEvent event) {
    if (event is PageStackPageBlocEvent) {
      if (event.pageBlocEvent is PageBlocPathChangedEvent) {
        notifyListeners();
      }
    }
  }
}
