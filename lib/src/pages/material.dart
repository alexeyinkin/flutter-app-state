import 'package:flutter/material.dart';

import 'abstract.dart';
import '../blocs/screen/screen.dart';

abstract class AbstractMaterialPage<C> extends MaterialPage implements AbstractPage<C> {
  final ValueKey _nonNullKey;

  @override
  ValueKey get key => _nonNullKey;

  @override
  ScreenBloc<C, dynamic>? get bloc => null;

  @override
  C? get currentConfiguration => null;

  const AbstractMaterialPage({
    required ValueKey key,
    required Widget child,
  })
      :
        _nonNullKey = key,
        super(
          key: key,
          child: child,
        );

  @override
  void dispose() {}
}
