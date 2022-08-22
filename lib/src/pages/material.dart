import 'dart:async';

import 'package:flutter/material.dart';

import '../blocs/page/page_state_mixin.dart';
import '../blocs/page/path.dart';
import '../blocs/page/pop_cause.dart';
import '../blocs/page/pop_event.dart';
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

  @Deprecated('Renamed to state in v0.7.0')
  @override
  PPageStateMixin<P, R>? get bloc => null;

  @override
  // ignore: deprecated_member_use_from_same_package
  PPageStateMixin<P, R>? get state => bloc;

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

@Deprecated('Renamed in v0.7.0')
typedef CAbstractMaterialPage<P extends PagePath, R>
    = PAbstractMaterialPage<P, R>;
