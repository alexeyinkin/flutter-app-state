import 'package:flutter/widgets.dart';

import '../page/configuration.dart';
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
          routeInformation.state as Map<String, dynamic>?,
        ) ??
        await parsePageStacksConfiguration(routeInformation) ??
        (throw Exception(
          'Could not parse the PageConfiguration to derive the stack from',
        ));
  }

  /// Parses the configuration for all stacks from the URL.
  ///
  /// Constructs the state with a single [PageConfiguration]
  /// returned by [parsePageConfiguration].
  ///
  /// Override this to return a custom stack.
  Future<PageStacksConfiguration?> parsePageStacksConfiguration(
    RouteInformation routeInformation,
  ) async {
    final pageConfiguration = await parsePageConfiguration(routeInformation);
    return pageConfiguration?.defaultStacksConfiguration;
  }

  /// Override this to parse your [PageConfiguration] classes.
  ///
  /// Returns `null` by default.
  Future<PageConfiguration?> parsePageConfiguration(
    RouteInformation routeInformation,
  ) async {
    return null;
  }
}
