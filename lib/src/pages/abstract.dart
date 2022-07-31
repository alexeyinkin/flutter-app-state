import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../blocs/page/bloc.dart';
import '../blocs/page/path.dart';

/// The base page class for this package.
///
/// [P] is the base class for all app's page paths.
/// [R] is the result returned when the page pops.
///
/// [key] is narrowed down to [ValueKey] of String because we need to compare it
/// to string keys in paths.
abstract class CAbstractPage<P extends PagePath, R> extends Page {
  @override
  ValueKey<String>? get key;

  @internal
  Completer<R?> get completer;

  /// The key to re-create this page with factory when recovering state.
  String? getFactoryKey();

  CPageBloc<P, R>? get bloc;

  P? get path;

  void dispose();
}

typedef AbstractPage<R> = CAbstractPage<PagePath, R>;
