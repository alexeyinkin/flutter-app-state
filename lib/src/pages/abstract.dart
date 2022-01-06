import 'package:flutter/widgets.dart';

import '../blocs/screen/screen.dart';

abstract class AbstractPage<C> extends Page {
  ScreenBloc<C, dynamic>? get bloc;
  C? get currentConfiguration;
  void dispose();
}
