import 'package:app_state/app_state.dart';
import 'package:flutter/foundation.dart';

import 'bloc.dart';
import 'screen.dart';

class InputPage extends StatefulMaterialPage<String, InputPageBloc> {
  static const classFactoryKey = 'Input';

  InputPage({required String name}) : super(
    key: const ValueKey(classFactoryKey),
    state: InputPageBloc(name: name),
    createScreen: InputScreen.new,
  );
}
