import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../page/path.dart';
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
  ) =>
      // ignore: deprecated_member_use_from_same_package
      parsePageConfiguration(routeInformation);

  @Deprecated('Use parsePagePath, see CHANGELOG for v0.6.2')
  @nonVirtual
  Future<PagePath?> parsePageConfiguration(
    RouteInformation routeInformation,
  ) async {
    return null;
  }
}
