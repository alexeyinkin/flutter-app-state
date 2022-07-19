import '../page/configuration.dart';
import '../page_stack/configuration.dart';
import 'bloc.dart';

/// Used to restore [PageStacksBloc] state, can be serialized
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
    required List<PageConfiguration> pageConfigurations,
  })  : pageStackConfigurations = <String, PageStackConfiguration>{
          key: PageStackConfiguration(
            pageConfigurations: pageConfigurations,
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
}
