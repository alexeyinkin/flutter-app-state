import 'package:flutter/widgets.dart';

import '../blocs/page/bloc.dart';
import '../blocs/page/path.dart';
import 'material.dart';

/// The base class for stateful pages.
///
/// [P] is the base class for all app's page path.
/// [R] is the result returned when the page pops.
/// [B] is the block for the state.
class CBlocMaterialPage<P extends PagePath, R,
    B extends CPageBloc<P, R>> extends CAbstractMaterialPage<P, R> {
  @override
  final B bloc;

  @override
  P? get path => bloc.path;

  CBlocMaterialPage({
    required this.bloc,
    required Widget Function(B) createScreen,
    super.key,
    super.factoryKey,
  }) : super(
          child: createScreen(bloc),
        );

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

typedef BlocMaterialPage<R, B extends PageBloc<R>>
    = CBlocMaterialPage<PagePath, R, B>;
