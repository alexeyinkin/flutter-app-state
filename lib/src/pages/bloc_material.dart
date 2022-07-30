import 'package:flutter/widgets.dart';

import '../blocs/page/bloc.dart';
import '../blocs/page/configuration.dart';
import 'material.dart';

/// The base class for stateful pages.
///
/// [C] is the base class for all app's page configurations.
/// [R] is the result returned when the page pops.
/// [B] is the block for the state.
abstract class CBlocMaterialPage<C extends PageConfiguration, R,
    B extends CPageBloc<C, R>> extends CAbstractMaterialPage<C, R> {
  @override
  final B bloc;

  @override
  C? getConfiguration() => bloc.getConfiguration();

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
  }
}

typedef BlocMaterialPage<R, B extends PageBloc<R>>
    = CBlocMaterialPage<PageConfiguration, R, B>;
