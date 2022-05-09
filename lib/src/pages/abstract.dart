import 'package:flutter/widgets.dart';

import '../blocs/page/configuration.dart';
import '../blocs/page/page.dart';

/// The base page class for this package.
///
/// [C] is the base class for all app's page configurations.
/// [key] is narrowed down to [ValueKey] of String because we need to compare it
/// to string keys in configurations.
abstract class AbstractPage<C extends PageConfiguration> extends Page {
  @override
  ValueKey<String>? get key;

  /// The key to re-create this page with factory when recovering state.
  String? getFactoryKey();

  PageBloc<C>? get bloc;

  C? getConfiguration();

  void dispose();
}
