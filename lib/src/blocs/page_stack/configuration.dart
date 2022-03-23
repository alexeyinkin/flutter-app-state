import '../page/configuration.dart';

/// Used to recover [PageConfiguration] objects, can be serialized
/// for browser history.
class PageStackConfiguration {
  final List<PageConfiguration?> pageConfigurations;

  PageStackConfiguration({
    required this.pageConfigurations,
  });

  static Map<String, PageStackConfiguration> fromMaps(Map<String, dynamic> maps) {
    return maps
        .cast<String, Map<String, dynamic>>()
        .map(
          (k, v) => MapEntry(k, PageStackConfiguration._fromMap(v)),
        );
  }

  factory PageStackConfiguration._fromMap(Map<String, dynamic> map) {
    return PageStackConfiguration(
      pageConfigurations: PageConfiguration.fromMaps(map['pc']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pc': PageConfiguration.toJsons(pageConfigurations),
    };
  }
}