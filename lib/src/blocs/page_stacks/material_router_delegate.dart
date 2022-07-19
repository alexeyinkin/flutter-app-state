import 'package:flutter/material.dart';

import 'bloc.dart';
import 'router_delegate.dart';

// TODO(alexeyinkin): Create a delegate like this independent from Material,
//       then deprecate this class,
//       https://github.com/alexeyinkin/flutter-app-state/issues/5
class MaterialPageStacksRouterDelegate extends PageStacksRouterDelegate {
  final Widget child;

  MaterialPageStacksRouterDelegate({
    required PageStacksBloc pageStacksBloc,
    required this.child,
  }) : super(pageStacksBloc);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: const ValueKey('HomePage'),
          child: child,
        ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        return true;
      },
    );
  }
}
