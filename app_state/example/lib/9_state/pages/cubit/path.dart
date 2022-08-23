import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import 'page.dart';
import '../home/path.dart';

class CubitPath extends PagePath {
  final int counter;

  static final _regExp = RegExp(r'^/cubit(/(\d+))?$');

  CubitPath({
    this.counter = 0,
  }) : super(
          key: CubitPage.classFactoryKey,
          state: {'counter': counter},
        );

  @override
  String get location => '/cubit/$counter';

  static CubitPath? tryParse(RouteInformation ri) {
    final matches = _regExp.firstMatch(ri.location ?? '');
    if (matches == null) return null;

    final counter = int.tryParse(matches[1] ?? '') ?? 0;

    return CubitPath(
      counter: counter,
    );
  }

  @override
  List<PagePath> get defaultStackPaths => [
        const HomePath(),
        this,
      ];
}
