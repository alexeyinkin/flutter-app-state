import 'package:app_state/app_state.dart';
import 'package:flutter/foundation.dart';

import 'screen.dart';
import 'state.dart';

class InputPage extends StatefulMaterialPage<String, InputPageNotifier> {
  static const classFactoryKey = 'Input';

  InputPage({required String name})
      : super(
          key: const ValueKey(classFactoryKey),
          state: InputPageNotifier(name: name),
          createScreen: InputScreen.new,
        );
}
