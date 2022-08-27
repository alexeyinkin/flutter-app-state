import '../page_state/path.dart';
import '../pages/abstract.dart';

typedef PPageFactoryFunction<P extends PagePath> = PAbstractPage<P, dynamic>?
    Function(
  String factoryKey,
  Map<String, dynamic> state,
);
