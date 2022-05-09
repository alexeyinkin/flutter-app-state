import 'package:flutter/widgets.dart';

import 'material.dart';
import '../blocs/page/configuration.dart';

abstract class StatelessMaterialPage<C extends PageConfiguration>
    extends AbstractMaterialPage<C> {
  final C? configuration;

  @override
  C? getConfiguration() => configuration;

  const StatelessMaterialPage({
    required ValueKey<String> key,
    String? factoryKey,
    required Widget child,
    this.configuration,
  }) : super(
          key: key,
          factoryKey: factoryKey,
          child: child,
        );
}
