import '../../../pages/abstract.dart';
import '../../page/path.dart';
import '../configuration.dart';
import 'abstract.dart';

class CNonePageStackConfigurationSetter<P extends PagePath>
    extends CAbstractPageStackConfigurationSetter<P> {
  @override
  void set({
    required List<CAbstractPage<P, dynamic>> pages,
    required PageStackConfiguration configuration,
    required void Function(PagePath) createAndPushPage,
  }) {
    pages.clear();

    for (final path in configuration.paths) {
      if (path == null) {
        // Pages without path are transient dialogs, these are OK
        // to skip. Otherwise we will never be able to recover good URLed pages
        // on top of transient dialogs.
        continue;
      }

      createAndPushPage(path);
    }
  }
}
