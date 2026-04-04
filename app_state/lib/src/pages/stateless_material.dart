import 'package:flutter/widgets.dart';

import '../page_state/path.dart';
import 'material.dart';

abstract class PStatelessMaterialPage<P extends PagePath, R>
    extends PAbstractMaterialPage<P, R> {
  @override
  final P? path;

  PStatelessMaterialPage({
    required ValueKey<String> super.key,
    required super.child,
    super.factoryKey,
    this.path,
  });
}

typedef StatelessMaterialPage<R> = PStatelessMaterialPage<PagePath, R>;

@Deprecated('Renamed to PStatelessMaterialPage')
typedef CStatelessMaterialPage<P extends PagePath, R>
    = PStatelessMaterialPage<P, R>;
