import 'dart:async';

import 'package:flutter/material.dart';

import '../blocs/page/bloc.dart';
import '../blocs/page/configuration.dart';
import 'abstract.dart';

abstract class CAbstractMaterialPage<C extends PageConfiguration, R>
    extends MaterialPage implements CAbstractPage<C, R> {
  final ValueKey<String>? _valueKey;

  @override
  ValueKey<String>? get key => _valueKey;

  final String? _factoryKey;

  // Don't use getter because 'factoryKey' is a convenient identifier
  // of a constant for user subclasses.
  @override
  String? getFactoryKey() => _factoryKey ?? _valueKey?.value;

  @override
  CPageBloc<C, R>? get bloc => null;

  @override
  C? getConfiguration() => null;

  @override
  final completer = Completer<R?>();

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
  void dispose() {}
}
