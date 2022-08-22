import 'package:app_state/app_state.dart';

import '../pages/home/page.dart';
import '../pages/bloc/page.dart';
import '../pages/change_notifier/page.dart';
import '../pages/cubit/page.dart';

class PageFactory {
  static AbstractPage? createPage(
    String factoryKey,
    Map<String, dynamic> state,
  ) {
    switch (factoryKey) {
      case HomePage.classFactoryKey:
        return HomePage();

      case BlocPage.classFactoryKey:
        return BlocPage(initialCount: state['counter']);

      case ChangeNotifierPage.classFactoryKey:
        return ChangeNotifierPage(initialCount: state['counter']);

      case CubitPage.classFactoryKey:
        return CubitPage(initialCount: state['counter']);
    }

    return null;
  }
}
