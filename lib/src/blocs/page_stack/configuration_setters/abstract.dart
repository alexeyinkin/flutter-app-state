import '../../../pages/abstract.dart';
import '../../page/path.dart';
import '../configuration.dart';

abstract class CAbstractPageStackConfigurationSetter<P extends PagePath> {
  void set({
    required List<CAbstractPage<P, dynamic>> pages,
    required PageStackConfiguration configuration,
    required void Function(PagePath) createAndPushPage,
  });
}
