import 'package:flutter/widgets.dart';

import '../blocs/page/bloc.dart';
import '../blocs/page/configuration.dart';
import 'material.dart';

/// The base class for stateful pages.
///
/// [C] is the base class for all app's page configurations.
/// [B] is the block for the state.
abstract class BlocMaterialPage<C extends PageConfiguration,
    B extends PageBloc<C>> extends AbstractMaterialPage<C> {
  @override
  final B bloc;

  @override
  C? getConfiguration() => bloc.getConfiguration();

  BlocMaterialPage({
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
