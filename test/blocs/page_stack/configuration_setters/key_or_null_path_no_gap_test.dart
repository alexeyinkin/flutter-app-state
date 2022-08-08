import 'package:app_state/app_state.dart';
import 'package:app_state/src/blocs/page_stack/configuration_setters/key_or_null_path_no_gap.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../common/common.dart';

void main() {
  group('CKeyOrNullPathNoGapConfigurationSetter', () {
    test(
        'preserves a page when keys match, '
        'applies page state when keys do not match, '
        'null path matches any page, '
        'drops mismatched, '
        'creates mismatched', () {
      final setter = CKeyOrNullPathNoGapPageStackConfigurationSetter();
      final page0 = HomePage();
      final page1 = BooksStatefulPage();
      final page2 = BookPage(id: 1);
      final page3 = BooksStatefulPage();
      final pages = <CAbstractPage>[page0, page1, page2, page3];
      const category1 = 'changed1';
      const category2 = 'changed2';
      final inPaths = [
        null, //                                   match
        BooksStatefulPath(category: category1), // match, apply state
        BookPath(id: 2), //                        mismatch, id
        BooksStatefulPath(category: category2) //  new, apply state
      ];
      final outPaths = <PagePath>[];

      setter.set(
        pages: pages,
        configuration: PageStackConfiguration(paths: inPaths),
        createAndPushPage: outPaths.add,
      );

      expect(pages.length, 2);
      expect(identical(pages[0], page0), true);
      expect(identical(pages[1], page1), true);
      expect(page1.bloc.category, category1);
      expect((outPaths[0] as BookPath).id, 2);
      expect((outPaths[1] as BooksStatefulPath).category, category2);
    });
  });
}
