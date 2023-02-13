import 'dart:async';

import 'package:flutter/widgets.dart';

import '../models/back_pressed_result_enum.dart';
import '../page_stack/page_stack.dart';
import '../page_state/page_state_mixin.dart';
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
      // Otherwise (if passing `bloc.pages`) on update the navigator would
      // diff the new list with itself and would not show a newly pushed route.
      pages: [...stack.pages],
      transitionDelegate: transitionDelegate,
      onPopPage: (route, result) {
        // This is required by Flutter's internals to complete the pop future.
        final didPop = route.didPop(result);

        final settings = route.settings;

        if (settings is StatefulMaterialPage) {
          // Ideally we want to await for bloc.onBackPressed to see if it
          // handled the event (so we ignore it) or not (so we propagate it).
          // But this callback is synchronous, so we always have to ignore it.
          // This means the app will never close on back button press.
          // TODO(alexeyinkin): Allow to close the app on back button,
          //  https://github.com/alexeyinkin/flutter-app-state/issues/8
          unawaited(_onBackButtonPressedInStatefulPage(settings.state));
          return false; // Prevent the default pop.
        }

        if (settings is Page) {
          // A page without state. It has no chance to override the behavior.
          unawaited(stack.onBackPressed());
          return false; // Prevent the default pop.
        }

        // The classic handler for non-paged routes:

        if (!didPop) {
          return false; // Prevent the default pop.
        }

        return true; // Continue with the default pop.
      },
    );
  }

  Future<void> _onBackButtonPressedInStatefulPage(PageStateMixin state) async {
    final result = await state.onBackPressed();
    if (result == BackPressedResult.close) {
      state.pop();
    }
  }
}
