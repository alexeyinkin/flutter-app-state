import 'package:app_state/app_state.dart';

import '../pages/home/page.dart';
import '../pages/input/page.dart';

class PageFactory {
  static AbstractPage? createPage(
    String factoryKey,
    Map<String, dynamic> state,
  ) {
    switch (factoryKey) {
      case HomePage.classFactoryKey:
        return HomePage();
      case InputPage.classFactoryKey:
        return InputPage();
    }

    return null;
  }
}
