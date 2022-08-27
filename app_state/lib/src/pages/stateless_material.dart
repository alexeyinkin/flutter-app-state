import 'package:flutter/widgets.dart';

import '../page_state/path.dart';
import 'material.dart';

abstract class CStatelessMaterialPage<P extends PagePath, R>
    extends PAbstractMaterialPage<P, R> {
  @override
  final P? path;

  CStatelessMaterialPage({
    required ValueKey<String> super.key,
    required super.child,
    super.factoryKey,
    this.path,
  });
}

typedef StatelessMaterialPage<R> = CStatelessMaterialPage<PagePath, R>;
