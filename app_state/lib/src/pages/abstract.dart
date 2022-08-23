import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../blocs/page/page_state_mixin.dart';
import '../blocs/page/path.dart';
import '../blocs/page/pop_cause.dart';
import '../blocs/page/pop_event.dart';

/// The base page class for this package.
///
/// [P] is the base class for all app's page paths.
/// [R] is the result returned when the page pops.
///
/// [key] is narrowed down to [ValueKey] of String because we need to compare it
/// to string keys in paths.
abstract class PAbstractPage<P extends PagePath, R> extends Page {
  @override
  ValueKey<String>? get key;

  @internal
  Completer<R?> get completer;

  bool get isDisposed;

  /// The key to re-create this page with factory when recovering state.
  String? getFactoryKey();

  @Deprecated('Use state')
  PPageStateMixin<P, R>? get bloc;

  PPageStateMixin<P, R>? get state;

  P? get path;

  void dispose();

  /// Creates [PagePopEvent].
  ///
  /// Useful for polymorphic creation of the event when [R] is not known.
  PagePopEvent<R> createPopEvent({
    required R? data,
    required PopCause cause,
  });
}

typedef AbstractPage<R> = PAbstractPage<PagePath, R>;

@Deprecated('Renamed to PAbstractPage in v0.7.0')
typedef CAbstractPage<P extends PagePath, R> = PAbstractPage<P, R>;
