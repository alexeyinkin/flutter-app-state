import '../../page_state/path.dart';
import '../../pages/abstract.dart';
import '../configuration.dart';

abstract class PAbstractPageStackConfigurationSetter<P extends PagePath> {
  void set({
    required List<PAbstractPage<P, dynamic>> pages,
    required PageStackConfiguration configuration,
    required void Function(PagePath) createAndPushPage,
  });
}
