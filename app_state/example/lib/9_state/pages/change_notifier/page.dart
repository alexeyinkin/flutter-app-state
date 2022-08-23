import 'package:app_state/app_state.dart';
import 'package:flutter/foundation.dart';

import 'screen.dart';
import 'state.dart';

class ChangeNotifierPage
    extends StatefulMaterialPage<void, CounterChangeNotifier> {
  static const classFactoryKey = 'ChangeNotifier';

  ChangeNotifierPage({
    required int initialCount,
  }) : super(
          key: ValueKey(classFactoryKey),
          state: CounterChangeNotifier(initialCount: initialCount),
          createScreen: (notifier) => ChangeNotifierScreen(notifier: notifier),
        );
}
