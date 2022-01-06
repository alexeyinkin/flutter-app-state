import 'package:flutter/material.dart';

import 'abstract.dart';
import '../blocs/screen/screen.dart';

abstract class AbstractMaterialPage<C> extends MaterialPage implements AbstractPage<C> {
  @override
  ScreenBloc<C, dynamic>? get bloc => null;

  @override
  C? get currentConfiguration => null;

  const AbstractMaterialPage({
    required LocalKey key,
    required Widget child,
  }) : super(
    key: key,
    child: child,
  );

  @override
  void dispose() {}
}
