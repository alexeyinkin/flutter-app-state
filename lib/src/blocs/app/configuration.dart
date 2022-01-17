import '../page/configuration.dart';
import '../page_stack/configuration.dart';

/// Used to restore [PageStackBloc] states, can be serialized
/// for browser history.
class AppConfiguration {
  final Map<String, PageStackConfiguration> pageStackConfigurations;

  const AppConfiguration({
    required this.pageStackConfigurations,
  });

  const AppConfiguration.empty() : pageStackConfigurations = const {};

  AppConfiguration.singleStack({
    required String key,
    required List<PageConfiguration> pageConfigurations,
  }) :
        pageStackConfigurations = <String, PageStackConfiguration>{
          key: PageStackConfiguration(
            pageConfigurations: pageConfigurations,
          ),
        };

  static AppConfiguration? fromMapOrNull(Map<String, dynamic>? map) {
    if (map == null) return null;

    return AppConfiguration(
      pageStackConfigurations: PageStackConfiguration.fromMaps(map['psc']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'psc': pageStackConfigurations,
    };
  }
}
