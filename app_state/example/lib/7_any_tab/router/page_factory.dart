import 'package:app_state/app_state.dart';

import '../pages/popup/page.dart';
import '../pages/tab1/page.dart';
import '../pages/tab2/page.dart';

class PageFactory {
  static AbstractPage? createPage(
    String factoryKey,
    Map<String, dynamic> state,
  ) {
    switch (factoryKey) {
      case PopupPage.classFactoryKey:
        return PopupPage();
      case Tab1Page.classFactoryKey:
        return Tab1Page();
      case Tab2Page.classFactoryKey:
        return Tab2Page();
    }

    return null;
  }
}
