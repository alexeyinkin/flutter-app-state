import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import 'page.dart';
import '../home/path.dart';

class BlocPath extends PagePath {
  final int counter;

  static final _regExp = RegExp(r'^/bloc(/(\d+))?$');

  BlocPath({
    this.counter = 0,
  }) : super(
          key: BlocPage.classFactoryKey,
          state: {'counter': counter},
        );

  @override
  Uri get uri => Uri.parse('/bloc/$counter');

  static BlocPath? tryParse(RouteInformation ri) {
    final matches = _regExp.firstMatch(ri.uri.path);
    if (matches == null) return null;

    final counter = int.tryParse(matches[1] ?? '') ?? 0;

    return BlocPath(
      counter: counter,
    );
  }

  @override
  List<PagePath> get defaultStackPaths => [
        const HomePath(),
        this,
      ];
}
