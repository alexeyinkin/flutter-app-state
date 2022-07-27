import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../blocs/page/bloc.dart';
import '../blocs/page/configuration.dart';

/// The base page class for this package.
///
/// [C] is the base class for all app's page configurations.
/// [R] is the result returned when the page pops.
///
/// [key] is narrowed down to [ValueKey] of String because we need to compare it
/// to string keys in configurations.
abstract class AbstractPage<C extends PageConfiguration, R> extends Page {
  @override
  ValueKey<String>? get key;

  @internal
  Completer<R?> get completer;

  /// The key to re-create this page with factory when recovering state.
  String? getFactoryKey();

  PageBloc<C, R>? get bloc;

  C? getConfiguration();

  void dispose();
}
