import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../page/path.dart';

/// Used to recover [PagePath] objects, can be serialized
/// for browser history.
class PageStackConfiguration {
  final List<PagePath?> paths;

  const PageStackConfiguration({
    List<PagePath?>? paths,
    @Deprecated('Use "path" instead. See CHANGELOG for v0.6.2')
        List<PagePath?>? pageConfigurations,
  })  : assert(
          paths != null || pageConfigurations != null,
          'A non-null path is required',
        ),
        paths = paths ?? pageConfigurations ?? const [];

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
  RouteInformation restoreRouteInformation() {
    return RouteInformation(
      // ignore: deprecated_member_use_from_same_package
      location: getTopPagePath()?.restoreRouteInformation().location ?? '/',
      state: toJson(),
    );
  }
}
