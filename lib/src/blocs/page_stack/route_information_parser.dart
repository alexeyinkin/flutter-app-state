import 'package:flutter/widgets.dart';

import '../page/configuration.dart';
import 'configuration.dart';

class PageStackRouteInformationParser
    extends RouteInformationParser<PageStackConfiguration> {
  const PageStackRouteInformationParser();

  @override
  RouteInformation? restoreRouteInformation(
    PageStackConfiguration configuration,
  ) {
    return configuration.restoreRouteInformation();
  }

  /// Parses the configuration for the whole stack from `state` or the URL.
  ///
  /// If [routeInformation].`state` has it, denormalizes it.
  /// Otherwise calls [parsePageStackConfiguration].
  ///
  /// Override this to disable `state` parsing.
  @override
  Future<PageStackConfiguration> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    return PageStackConfiguration.fromMapOrNull(
          routeInformation.state as Map<String, dynamic>?,
        ) ??
        await parsePageStackConfiguration(routeInformation);
  }

  /// Parses the configuration for the whole stack from the URL.
  ///
  /// Constructs the state with a single [PageConfiguration]
  /// returned by [parsePageConfiguration].
  ///
  /// Override this to return a custom stack.
  Future<PageStackConfiguration> parsePageStackConfiguration(
    RouteInformation routeInformation,
  ) async {
    final pageConfiguration = await parsePageConfiguration(routeInformation);

    if (pageConfiguration == null) {
      return const PageStackConfiguration(
        pageConfigurations: [null],
      );
    }

    return pageConfiguration.defaultStackConfiguration;
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
