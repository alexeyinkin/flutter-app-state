import 'package:app_state/app_state.dart';

import '../pages/about/page.dart';
import '../pages/book_details/page.dart';
import '../pages/book_list/page.dart';

class PageFactory {
  static AbstractPage? createPage(
    String factoryKey,
    Map<String, dynamic> state,
  ) {
    switch (factoryKey) {
      case AboutPage.classFactoryKey: return AboutPage();
      case BookDetailsPage.classFactoryKey: return BookDetailsPage(bookId: state['bookId']);
      case BookListPage.classFactoryKey: return BookListPage();
    }

    return null;
  }
}
