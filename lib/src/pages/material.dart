import 'package:flutter/material.dart';

import 'abstract.dart';
import '../blocs/page/bloc.dart';
import '../blocs/page/configuration.dart';

abstract class AbstractMaterialPage<C extends PageConfiguration>
    extends MaterialPage implements AbstractPage<C> {
  final ValueKey<String>? _valueKey;

  @override
  ValueKey<String>? get key => _valueKey;

  final String? _factoryKey;

  // Don't use getter because 'factoryKey' is a convenient identifier
  // of a constant for user subclasses.
  @override
  String? getFactoryKey() => _factoryKey ?? _valueKey?.value;

  @override
  PageBloc<C>? get bloc => null;

  @override
  C? getConfiguration() => null;

  const AbstractMaterialPage({
    ValueKey<String>? key,
    String? factoryKey,
    required Widget child,
  })  : _valueKey = key,
        _factoryKey = factoryKey,
        super(
          key: key,
          child: child,
        );

  @override
  void dispose() {}
}
