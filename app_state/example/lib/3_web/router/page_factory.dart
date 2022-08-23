import 'package:app_state/app_state.dart';

import '../pages/book_details/page.dart';
import '../pages/book_list/page.dart';

class PageFactory {
  static AbstractPage? createPage(
    String factoryKey,
    Map<String, dynamic> state,
  ) {
    switch (factoryKey) {
      case BookDetailsPage.classFactoryKey:
        return BookDetailsPage(bookId: state['bookId']);
      case BookListPage.classFactoryKey:
        return BookListPage();
    }

    return null;
  }
}
