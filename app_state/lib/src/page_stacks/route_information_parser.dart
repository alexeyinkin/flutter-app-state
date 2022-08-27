import 'package:flutter/widgets.dart';
import 'package:flutter_issue_108697_workaround/flutter_issue_108697_workaround.dart';

import '../page_state/path.dart';
import 'configuration.dart';

abstract class PageStacksRouteInformationParser
    extends RouteInformationParser<PageStacksConfiguration> {
  @override
  const PageStacksRouteInformationParser();

  @override
  RouteInformation? restoreRouteInformation(
    PageStacksConfiguration configuration,
  ) {
    return configuration.restoreRouteInformation();
  }

  @override
  Future<PageStacksConfiguration> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    return PageStacksConfiguration.fromMapOrNull(
          apply108697Workaround(routeInformation).state
              as Map<String, dynamic>?,
        ) ??
        await parsePageStacksConfiguration(routeInformation) ??
        (throw Exception(
          'Could not parse the PagePath to derive the stack from',
        ));
  }

  /// Parses the configuration for all stacks from the URL.
  ///
  /// Constructs the state with a single [PagePath]
  /// returned by [parsePagePath].
  ///
  /// Override this to return a custom stack.
  Future<PageStacksConfiguration?> parsePageStacksConfiguration(
    RouteInformation routeInformation,
  ) async {
    final pageConfiguration = await parsePagePath(routeInformation);
    return pageConfiguration?.defaultStacksConfiguration;
  }

  /// Override this to parse your [PagePath] classes.
  ///
  /// Returns `null` by default.
  Future<PagePath?> parsePagePath(
    RouteInformation routeInformation,
  ) async {
    return null;
  }
}
