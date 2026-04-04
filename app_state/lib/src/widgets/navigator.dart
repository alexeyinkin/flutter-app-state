import 'dart:async';

import 'package:flutter/widgets.dart';

import '../page_stack/page_stack.dart';
import '../pages/stateful_material.dart';

/// Builds a [Navigator] using [PPageStack.pages].
class PageStackNavigator extends StatelessWidget {
  final Key? navigatorKey;
  final PageStack stack;
  final List<NavigatorObserver> observers;
  final TransitionDelegate<dynamic> transitionDelegate;

  const PageStackNavigator({
    required this.stack,
    super.key,
    this.navigatorKey,
    this.observers = const <NavigatorObserver>[],
    this.transitionDelegate = const DefaultTransitionDelegate<dynamic>(),
  });

  @override
  Widget build(BuildContext context) {
    // TODO(alexeyinkin): Only rebuild on configuration change events,
    //  https://github.com/alexeyinkin/flutter-app-state/issues/7
    return StreamBuilder(
      stream: stack.events,
      builder: (context, snapshot) => _buildOnChange(),
    );
  }

  Widget _buildOnChange() {
    return Navigator(
      key: navigatorKey,
      observers: observers,
      // Pass the current copy of the pages list.
      // Otherwise (without copying) on update the navigator would
      // diff the new list with itself and would not show a newly pushed route.
      pages: [...stack.pages],
      transitionDelegate: transitionDelegate,
      onDidRemovePage: (page) {
        if (page is PStatefulMaterialPage) {
          throw Exception(
            'Must never get here '
            'because stateful pages use PopScope with canPop = false, '
            'which prevents Navigator from handling their events.',
          );
        }

        // This is only called for stateless pages because stateful ones
        // use PopScope (with canPop = false) to handle popping.
        unawaited(stack.onBackPressed());
      },
    );
  }
}
