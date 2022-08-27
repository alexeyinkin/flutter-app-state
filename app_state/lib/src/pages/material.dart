import 'dart:async';

import 'package:flutter/material.dart';

import '../page_state/page_state_mixin.dart';
import '../page_state/path.dart';
import '../page_state/pop_cause.dart';
import '../page_state/pop_event.dart';
import '../util/util.dart';
import 'abstract.dart';

abstract class PAbstractMaterialPage<P extends PagePath, R> extends MaterialPage
    implements PAbstractPage<P, R> {
  final ValueKey<String>? _valueKey;

  @override
  ValueKey<String>? get key => _valueKey;

  final String? _factoryKey;

  // Don't use getter because 'factoryKey' is a convenient identifier
  // of a constant for user subclasses.
  @override
  String? getFactoryKey() => _factoryKey ?? _valueKey?.value;

  @override
  PPageStateMixin<P, R>? get state => null;

  @override
  P? get path => null;

  @override
  final completer = Completer<R?>();

  final _isDisposed = Wrapper<bool>(false);

  @override
  bool get isDisposed => _isDisposed.value;

  PAbstractMaterialPage({
    required super.child,
    ValueKey<String>? key,
    String? factoryKey,
  })  : _valueKey = key,
        _factoryKey = factoryKey,
        super(
          key: key,
        );

  @override
  PagePopEvent<R> createPopEvent({
    required R? data,
    required PopCause cause,
  }) =>
      PagePopEvent<R>(data: data, cause: cause);

  @override
  @mustCallSuper
  void dispose() {
    _isDisposed.value = true;
  }
}
