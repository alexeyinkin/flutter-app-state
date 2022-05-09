import 'package:flutter/widgets.dart';

import '../page/configuration_changed_event.dart';
import 'configuration.dart';
import 'event.dart';
import 'page_event.dart';
import 'page_stack.dart';
import '../../widgets/navigator.dart';

class PageStackRouterDelegate extends RouterDelegate<PageStackConfiguration>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<PageStackConfiguration> {
  final PageStackBloc pageStackBloc;

  PageStackRouterDelegate(this.pageStackBloc) {
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
    return PageStackBlocNavigator(
      bloc: pageStackBloc,
    );
  }

  @override
  Future<void> setNewRoutePath(PageStackConfiguration configuration) async {
    return pageStackBloc.setConfiguration(configuration);
  }

  void _onPageStackEvent(PageStackBlocEvent event) {
    if (event is PageStackPageBlocEvent) {
      if (event.pageBlocEvent is PageBlocConfigurationChangedEvent) {
        notifyListeners();
      }
    }
  }
}
