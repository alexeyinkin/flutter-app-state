import 'package:app_state/app_state.dart';
import 'package:app_state/src/blocs/page_stack/configuration_setters/none.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../common/common.dart';

void main() {
  group('CNonePageStackConfigurationSetter', () {
    test('cleans pages, sets new non-null paths', () {
      final setter = CNonePageStackConfigurationSetter();
      final page0 = HomePage();
      final pages = [page0];
      const inPaths = [HomePath(), null, AltHomePath()];
      final outPaths = <PagePath>[];

      setter.set(
        pages: pages,
        configuration: const PageStackConfiguration(paths: inPaths),
        createAndPushPage: outPaths.add,
      );

      expect(pages, const []);
      expect(outPaths, const [HomePath(), AltHomePath()]);
    });
  });
}
