import 'package:app_state/app_state.dart';
import 'package:flutter/foundation.dart';

import 'screen.dart';
import 'state.dart';

class BlocPage extends StatefulMaterialPage<void, CounterBloc> {
  static const classFactoryKey = 'Bloc';

  BlocPage({
    required int initialCount,
  }) : super(
          key: ValueKey(classFactoryKey),
          state: CounterBloc(initialCount: initialCount),
          createScreen: (bloc) => BlocScreen(bloc: bloc),
        );
}
