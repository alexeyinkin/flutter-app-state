import 'package:flutter/widgets.dart';
import 'package:flutter_issue_108697_workaround/flutter_issue_108697_workaround.dart';
import 'package:meta/meta.dart';

import '../page/path.dart';
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
          apply108697Workaround(routeInformation).state
              as Map<String, dynamic>?,
        ) ??
        await parsePageStackConfiguration(routeInformation);
  }

  /// Parses the configuration for the whole stack from the URL.
  ///
  /// Constructs the state with a single [PagePath]
  /// returned by [parsePagePath].
  ///
  /// Override this to return a custom stack.
  Future<PageStackConfiguration> parsePageStackConfiguration(
    RouteInformation routeInformation,
  ) async {
    final path = await parsePagePath(routeInformation);

    if (path == null) {
      return const PageStackConfiguration(
        paths: [null],
      );
    }

    return path.defaultStackConfiguration;
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
