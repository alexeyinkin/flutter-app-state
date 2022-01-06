import 'package:flutter/widgets.dart';

import 'material.dart';
import '../blocs/screen/screen.dart';

abstract class BlocMaterialPage<C, B extends ScreenBloc<C, dynamic>> extends AbstractMaterialPage<C> {
  @override
  final B bloc;

  @override
  C? get currentConfiguration => bloc.currentConfiguration;

  BlocMaterialPage({
    required LocalKey key,
    required this.bloc,
    required Widget Function(B) createScreen,
  }) : super(
    key: key,
    child: createScreen(bloc),
  );

  @override
  void dispose() {
    bloc.dispose();
  }
}
