import '../../pages/abstract.dart';
import '../page/path.dart';

typedef PPageFactoryFunction<P extends PagePath> = PAbstractPage<P, dynamic>?
    Function(
  String factoryKey,
  Map<String, dynamic> state,
);

@Deprecated('Renamed to PPageFactoryFunction in v0.7.0')
typedef CPageFactoryFunction<P extends PagePath> = PPageFactoryFunction<P>;
