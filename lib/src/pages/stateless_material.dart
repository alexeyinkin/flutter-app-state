import 'package:flutter/widgets.dart';

import '../blocs/page/path.dart';
import 'material.dart';

abstract class CStatelessMaterialPage<P extends PagePath, R>
    extends CAbstractMaterialPage<P, R> {
  @override
  final P? path;

  CStatelessMaterialPage({
    required ValueKey<String> super.key,
    required super.child,
    super.factoryKey,
    P? path,
    @Deprecated('Use "path" instead. See CHANGELOG for v0.6.2')
        P? configuration,
  }) : path = path ?? configuration;
}

typedef StatelessMaterialPage<R> = CStatelessMaterialPage<PagePath, R>;
