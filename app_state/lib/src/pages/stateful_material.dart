import 'package:flutter/widgets.dart';

import '../blocs/page/page_state_mixin.dart';
import '../blocs/page/path.dart';
import 'material.dart';

/// The base class for stateful pages.
///
/// [P] is the base class for all app's page path.
/// [R] is the result returned when the page pops.
/// [S] is the state class.
class PStatefulMaterialPage<P extends PagePath, R,
    S extends PPageStateMixin<P, R>> extends PAbstractMaterialPage<P, R> {
  @override
  final S state;

  @Deprecated('Use state')
  @override
  S get bloc => state;

  @override
  P? get path => state.path;

  PStatefulMaterialPage({
    required this.state,
    required Widget Function(S) createScreen,
    super.key,
    super.factoryKey,
  }) : super(
          child: createScreen(state),
        );

  @override
  void dispose() {
    state.dispose();
    super.dispose();
  }
}

typedef StatefulMaterialPage<R, S extends PageStateMixin<R>>
    = PStatefulMaterialPage<PagePath, R, S>;

@Deprecated('Use StatefulMaterialPage')
typedef BlocMaterialPage<R, S extends PageStateMixin<R>>
    = PStatefulMaterialPage<PagePath, R, S>;

@Deprecated('Use PStatefulMaterialPage')
typedef CBlocMaterialPage<R, S extends PageStateMixin<R>>
    = PStatefulMaterialPage<PagePath, R, S>;
