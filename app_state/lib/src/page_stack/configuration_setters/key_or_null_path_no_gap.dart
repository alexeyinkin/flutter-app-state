import 'dart:math';

import '../../page_state/path.dart';
import '../../pages/abstract.dart';
import '../configuration.dart';
import 'abstract.dart';

class PKeyOrNullPathNoGapPageStackConfigurationSetter<P extends PagePath>
    extends PAbstractPageStackConfigurationSetter<P> {
  @override
  void set({
    required List<PAbstractPage<P, dynamic>> pages,
    required PageStackConfiguration configuration,
    required void Function(PagePath) createAndPushPage,
  }) {
    int matchedIndex = 0;
    final matchLength = min(
      pages.length,
      configuration.paths.length,
    );

    for (; matchedIndex < matchLength; matchedIndex++) {
      final page = pages[matchedIndex];
      final path = configuration.paths[matchedIndex];

      if (path == null) {
        // A null PagePath is implied to match any page,
        // and it cannot apply any state to it.
        // The only production case for it is non-web where this diff
        // only happens at startup and does nothing.
        continue;
      }

      if (page.key?.value != path.key) {
        break; // Mismatch. Will dispose this page and above.
      }

      page.state?.setStateMap(path.state);
    }

    pages.removeRange(matchedIndex, pages.length);

    for (int i = matchedIndex; i < configuration.paths.length; i++) {
      final path = configuration.paths[i];
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
