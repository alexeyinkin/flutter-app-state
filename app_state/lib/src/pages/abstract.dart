import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../page_state/page_state_mixin.dart';
import '../page_state/path.dart';
import '../page_state/pop_cause.dart';
import '../page_state/pop_event.dart';

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
