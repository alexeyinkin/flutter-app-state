import 'package:app_state/app_state.dart';
import 'package:flutter/foundation.dart';

import 'screen.dart';
import 'state.dart';

class CubitPage extends StatefulMaterialPage<void, CounterCubit> {
  static const classFactoryKey = 'Cubit';

  CubitPage({
    required int initialCount,
  }) : super(
          key: ValueKey(classFactoryKey),
          state: CounterCubit(initialCount: initialCount),
          createScreen: (cubit) => CubitScreen(cubit: cubit),
        );
}
