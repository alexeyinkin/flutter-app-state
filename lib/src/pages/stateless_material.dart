import 'package:flutter/widgets.dart';

import '../blocs/page/configuration.dart';
import 'material.dart';

abstract class CStatelessMaterialPage<C extends PageConfiguration, R>
    extends CAbstractMaterialPage<C, R> {
  final C? configuration;

  @override
  C? getConfiguration() => configuration;

  CStatelessMaterialPage({
    required ValueKey<String> super.key,
    required super.child,
    super.factoryKey,
    this.configuration,
  });
}

typedef StatelessMaterialPage<R> = CStatelessMaterialPage<PageConfiguration, R>;
