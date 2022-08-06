import 'dart:async';

import 'package:flutter/material.dart';

import '../blocs/page/bloc.dart';
import '../blocs/page/path.dart';
import '../blocs/page/pop_cause.dart';
import '../blocs/page/pop_event.dart';
import '../util/util.dart';
import 'abstract.dart';

abstract class CAbstractMaterialPage<P extends PagePath, R> extends MaterialPage
    implements CAbstractPage<P, R> {
  final ValueKey<String>? _valueKey;

  @override
  ValueKey<String>? get key => _valueKey;

  final String? _factoryKey;

  // Don't use getter because 'factoryKey' is a convenient identifier
  // of a constant for user subclasses.
  @override
  String? getFactoryKey() => _factoryKey ?? _valueKey?.value;

  @override
  CPageBloc<P, R>? get bloc => null;

  @override
  P? get path => null;

  @override
  final completer = Completer<R?>();

  final _isDisposed = Wrapper<bool>(false);

  @override
  bool get isDisposed => _isDisposed.value;

  CAbstractMaterialPage({
    required super.child,
    ValueKey<String>? key,
    String? factoryKey,
  })  : _valueKey = key,
        _factoryKey = factoryKey,
        super(
          key: key,
        );

  @override
  PageBlocPopEvent createPopEvent({
    required R? data,
    required PopCause cause,
  }) =>
      PageBlocPopEvent<R>(data: data, cause: cause);

  @override
  @mustCallSuper
  void dispose() {
    _isDisposed.value = true;
  }
}
