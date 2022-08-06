import '../../pages/abstract.dart';
import '../page/path.dart';

typedef CPageFactoryFunction<P extends PagePath> = CAbstractPage<P, dynamic>?
    Function(
  String factoryKey,
  Map<String, dynamic> state,
);
