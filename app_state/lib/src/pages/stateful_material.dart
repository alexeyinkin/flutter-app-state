import 'dart:async';

import 'package:flutter/widgets.dart';

import '../models/back_pressed_result_enum.dart';
import '../page_state/page_state_mixin.dart';
import '../page_state/path.dart';
import 'material.dart';

/// The base class for stateful pages.
///
/// [P] is the base class for all app's page path.
/// [R] is the result returned when the page pops.
/// [S] is the state class.
class PStatefulMaterialPage<P extends PagePath, R,
    S extends PPageStateMixin<P, R>> extends PAbstractMaterialPage<P, R> {
  @override
  final S state;

  @override
  P? get path => state.path;

  PStatefulMaterialPage({
    required this.state,
    required Widget Function(S) createScreen,
    super.key,
    super.factoryKey,
  }) : super(
          // A stateful page handles pop asynchronously.
          // Therefore, the pop by the framework must always be disabled
          // because the framework only does that synchronously.
          // If the page decides to proceed with the pop, it does so manually
          // in the following handler.
          child: PopScope(
            canPop: false, // Prevents the pop by the framework.
            onPopInvokedWithResult: (bool didPop, dynamic result) async {
              if (didPop) {
                // Never get here.
                return;
              }

              final result = await state.onBackPressed();
              if (result == BackPressedResult.close) {
                state.pop();
              }
            },
            child: createScreen(state),
          ),
        );

  @override
  void dispose() {
    unawaited(state.dispose());
    super.dispose();
  }
}

typedef StatefulMaterialPage<R, S extends PageStateMixin<R>>
    = PStatefulMaterialPage<PagePath, R, S>;
