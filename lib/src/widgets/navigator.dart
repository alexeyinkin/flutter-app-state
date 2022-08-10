import 'package:flutter/widgets.dart';

import '../blocs/page/bloc.dart';
import '../blocs/page_stack/bloc.dart';
import '../models/back_pressed_result_enum.dart';
import '../pages/bloc_material.dart';

/// Builds a [Navigator] using [PageStackBloc]'s pages.
class PageStackBlocNavigator extends StatelessWidget {
  final PageStackBloc bloc;
  final List<NavigatorObserver> observers;
  final TransitionDelegate<dynamic> transitionDelegate;

  const PageStackBlocNavigator({
    required this.bloc,
    super.key,
    this.observers = const <NavigatorObserver>[],
    this.transitionDelegate = const DefaultTransitionDelegate<dynamic>(),
  });

  @override
  Widget build(BuildContext context) {
    // TODO(alexeyinkin): Only rebuild on configuration change events,
    //  https://github.com/alexeyinkin/flutter-app-state/issues/7
    return StreamBuilder(
      stream: bloc.events,
      builder: (context, snapshot) => _buildOnChange(),
    );
  }

  Widget _buildOnChange() {
    return Navigator(
      observers: observers,
      // Pass the current copy of the pages list.
      // Otherwise (if passing `bloc.pages`) on update the navigator would
      // diff the new list with itself and would not show a newly pushed route.
      pages: [...bloc.pages],
      transitionDelegate: transitionDelegate,
      onPopPage: (route, result) {
        // This is required by Flutter's internals to complete the pop future.
        final didPop = route.didPop(result);

        final settings = route.settings;

        if (settings is BlocMaterialPage) {
          // Ideally we want to await for bloc.onBackPressed to see if it
          // handled the event (so we ignore it) or not (so we propagate it).
          // But this callback is synchronous, so we always have to ignore it.
          // This means the app will never close on back button press.
          // TODO(alexeyinkin): Allow to close the app on back button,
          //  https://github.com/alexeyinkin/flutter-app-state/issues/8
          _onBackButtonPressedInBloc(settings.bloc);
          return false; // Prevent the default pop.
        }

        if (settings is Page) {
          // A page without bloc. It has no chance to override the behavior.
          bloc.onBackPressed();
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

  Future<void> _onBackButtonPressedInBloc(PageBloc bloc) async {
    final result = await bloc.onBackPressed();
    if (result == BackPressedResult.close) {
      bloc.pop();
    }
  }
}
