import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../page_state/path.dart';

/// Used to recover [PagePath] objects, can be serialized
/// for browser history.
class PageStackConfiguration {
  final List<PagePath?> paths;

  const PageStackConfiguration({
    required this.paths,
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
      paths: PagePath.fromMaps(map['p']),
    );
  }

  /// Returns a map describing this state to be stored in the browser history.
  Map<String, dynamic> toJson() {
    return {
      'p': PagePath.toJsons(paths),
    };
  }

  /// The first non-null page path from top.
  PagePath? getTopPagePath() {
    return paths.reversed.firstWhereOrNull((c) => c != null);
  }

  /// Returns [RouteInformation] that has the top [PagePath]'s location
  /// and all pages' states.
  RouteInformation? restoreRouteInformation() {
    final location = getTopPagePath()?.location;

    if (location == null) {
      return null;
    }

    return RouteInformation(location: location, state: toJson());
  }
}
