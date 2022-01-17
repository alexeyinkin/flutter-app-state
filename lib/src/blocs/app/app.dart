import 'configuration.dart';
import '../page_stack/page_stack.dart';

/// A container for [PageStackBloc] objects.
class AppBloc {
  final _pageStacks = <String, PageStackBloc>{};

  void addPageStack(String key, PageStackBloc bloc) {
    _pageStacks[key] = bloc;
  }

  AppConfiguration getConfiguration() {
    return AppConfiguration(
      pageStackConfigurations: _pageStacks.map(
        (key, pageStackBloc) => MapEntry(key, pageStackBloc.getConfiguration()),
      ),
    );
  }

  void setConfiguration(AppConfiguration state, {bool fire = true}) {
    for (final entry in state.pageStackConfigurations.entries) {
      _pageStacks[entry.key]?.setConfiguration(entry.value, fire: fire);
    }
  }
}
