import 'dart:async';

import 'package:flutter/material.dart';

import '../blocs/page/bloc.dart';
import '../blocs/page/path.dart';
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

  bool _isDisposed = false;

  @override
  bool get isDisposed => _isDisposed;

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
  @mustCallSuper
  void dispose() {
    _isDisposed = true;
  }
}
