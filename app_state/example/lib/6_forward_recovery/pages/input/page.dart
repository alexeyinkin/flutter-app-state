import 'package:app_state/app_state.dart';
import 'package:flutter/foundation.dart';

import 'screen.dart';
import 'state.dart';

class InputPage extends StatefulMaterialPage<void, InputState> {
  static const classFactoryKey = 'Input';

  InputPage()
      : super(
          state: InputState(),
          createScreen: InputScreen.new,
          key: const ValueKey(classFactoryKey),
          factoryKey: classFactoryKey,
        );
}
