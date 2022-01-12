import 'package:flutter/widgets.dart';

import 'material.dart';
import '../blocs/screen/screen.dart';

/// The base class for stateful pages.
///
/// [C] is the base class for all app's page configurations.
/// [B] is the block for the state.
abstract class BlocMaterialPage<C, B extends ScreenBloc<C, dynamic>> extends AbstractMaterialPage<C> {
  @override
  final B bloc;

  @override
  C? get currentConfiguration => bloc.currentConfiguration;

  BlocMaterialPage({
    required ValueKey key,
    required this.bloc,
    required Widget Function(B) createScreen,
  })
      :
        super(
          key: key,
          child: createScreen(bloc),
        );

  @override
  void dispose() {
    bloc.dispose();
  }
}
