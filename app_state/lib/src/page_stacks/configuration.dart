import 'package:flutter/widgets.dart';

import '../page_stack/configuration.dart';
import '../page_state/path.dart';
import 'page_stacks.dart';

/// Used to restore [PageStacks] state, can be serialized
/// for browser history.
class PageStacksConfiguration {
  final Map<String, PageStackConfiguration> pageStackConfigurations;
  final String? currentStackKey;

  const PageStacksConfiguration({
    required this.pageStackConfigurations,
    required this.currentStackKey,
  });

  const PageStacksConfiguration.empty()
      : pageStackConfigurations = const {},
        currentStackKey = '';

  PageStacksConfiguration.singleStack({
    required String key,
    required List<PagePath> paths,
  })  : pageStackConfigurations = <String, PageStackConfiguration>{
          key: PageStackConfiguration(
            paths: paths,
          ),
        },
        currentStackKey = key;

  static PageStacksConfiguration? fromMapOrNull(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }

    return PageStacksConfiguration(
      pageStackConfigurations: PageStackConfiguration.fromMaps(map['psc']),
      currentStackKey: map['k'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'psc': pageStackConfigurations,
      'k': currentStackKey,
    };
  }

  PageStackConfiguration? get currentStackConfiguration {
    return pageStackConfigurations[currentStackKey];
  }

  RouteInformation? restoreRouteInformation() {
    final location = currentStackConfiguration?.getTopPagePath()?.location;

    if (location == null) {
      return null;
    }

    return RouteInformation(location: location, state: toJson());
  }
}
