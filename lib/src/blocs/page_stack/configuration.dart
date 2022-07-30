import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../page/configuration.dart';

/// Used to recover [PageConfiguration] objects, can be serialized
/// for browser history.
class PageStackConfiguration {
  final List<PageConfiguration?> pageConfigurations;

  const PageStackConfiguration({
    required this.pageConfigurations,
  });

  /// Recovers normalized states from a map.
  ///
  /// [maps] keys are stack keys, and the values are the normalized
  /// stack states.
  static Map<String, PageStackConfiguration> fromMaps(
    Map<String, dynamic> maps,
  ) {
    return maps.cast<String, Map<String, dynamic>>().map(
          (k, v) => MapEntry(k, PageStackConfiguration._fromMap(v)),
        );
  }

  static PageStackConfiguration? fromMapOrNull(Map<String, dynamic>? map) {
    if (map == null) return null;
    return PageStackConfiguration._fromMap(map);
  }

  factory PageStackConfiguration._fromMap(Map<String, dynamic> map) {
    return PageStackConfiguration(
      pageConfigurations: PageConfiguration.fromMaps(map['pc']),
    );
  }

  /// Returns a map describing this state to be stored in the browser history.
  Map<String, dynamic> toJson() {
    return {
      'pc': PageConfiguration.toJsons(pageConfigurations),
    };
  }

  /// The first non-null page configuration from top.
  PageConfiguration? getTopPageConfiguration() {
    return pageConfigurations.reversed.firstWhereOrNull((c) => c != null);
  }

  /// Returns [RouteInformation] that has the top [PageConfiguration]'s location
  /// and all pages' states.
  RouteInformation restoreRouteInformation() {
    return RouteInformation(
      location: getTopPageConfiguration()?.location ?? '/',
      state: toJson(),
    );
  }
}
