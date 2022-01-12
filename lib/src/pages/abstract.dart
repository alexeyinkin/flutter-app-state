import 'package:flutter/widgets.dart';

import '../blocs/screen/screen.dart';

/// The base page class for this package.
///
/// [C] is the base class for all app's page configurations.
abstract class AbstractPage<C> extends Page {
  @override
  ValueKey get key;

  ScreenBloc<C, dynamic>? get bloc;
  C? get currentConfiguration;
  void dispose();
}
