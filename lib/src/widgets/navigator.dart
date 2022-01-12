import 'package:flutter/widgets.dart';

import '../blocs/page_stack/page_stack.dart';

/// Builds a [Navigator] using [PageStackBloc]'s pages.
class PageStackBlocNavigator extends StatelessWidget {
  final PageStackBloc bloc;

  const PageStackBlocNavigator({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Only rebuild on configuration change events.
    return StreamBuilder(
      stream: bloc.events,
      builder: (context, snapshot) => _buildOnChange(),
    );
  }

  Widget _buildOnChange() {
    return Navigator(
      // Pass the current copy of the pages list.
      // Otherwise (if passing `bloc.pages`) on update the navigator would
      // diff the new list with itself and would not show a newly pushed route.
      pages: [...bloc.pages],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        return true;
      },
    );
  }
}
