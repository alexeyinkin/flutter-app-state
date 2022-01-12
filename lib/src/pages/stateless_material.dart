import 'package:flutter/widgets.dart';

import 'material.dart';

abstract class StatelessMaterialPage<C> extends AbstractMaterialPage<C> {
  final C? configuration;

  @override
  C? get currentConfiguration => configuration;

  const StatelessMaterialPage({
    required ValueKey key,
    required Widget child,
    this.configuration,
  })
      :
        super(
          key: key,
          child: child,
        );
}
