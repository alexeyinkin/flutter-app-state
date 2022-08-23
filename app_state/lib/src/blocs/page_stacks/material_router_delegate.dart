import 'package:flutter/material.dart';

import 'router_delegate.dart';

// TODO(alexeyinkin): Create a delegate like this independent from Material,
//       then deprecate this class,
//       https://github.com/alexeyinkin/flutter-app-state/issues/5

/// Builds the root [Navigator] which is set to always show only one page
/// with [child] for its widget.
///
/// [child] normally contains tabs with their nested navigators.
/// It is possible to not use the root navigator at all and just return
/// [child] as the root widget, but there are minor issues with this in Flutter:
/// https://github.com/flutter/flutter/issues/88169
/// https://stackoverflow.com/questions/51760916/hero-animation-not-working-inside-nested-navigator
///
/// [Navigator] here solves these issues.
class MaterialPageStacksRouterDelegate extends PageStacksRouterDelegate {
  final Widget child;

  MaterialPageStacksRouterDelegate(
    super.pageStacks, {
    required this.child,
  });

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
