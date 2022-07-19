import 'package:flutter/widgets.dart';

import '../blocs/page/configuration.dart';
import 'material.dart';

abstract class StatelessMaterialPage<C extends PageConfiguration>
    extends AbstractMaterialPage<C> {
  final C? configuration;

  @override
  C? getConfiguration() => configuration;

  const StatelessMaterialPage({
    required ValueKey<String> super.key,
    required super.child,
    super.factoryKey,
    this.configuration,
  });
}
