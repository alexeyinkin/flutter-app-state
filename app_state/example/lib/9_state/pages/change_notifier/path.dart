import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import 'page.dart';
import '../home/path.dart';

class ChangeNotifierPath extends PagePath {
  final int counter;

  static final _regExp = RegExp(r'^/change-notifier(/(\d+))?$');

  ChangeNotifierPath({
    this.counter = 0,
  }) : super(
          key: ChangeNotifierPage.classFactoryKey,
          state: {'counter': counter},
        );

  @override
  String get location => '/change-notifier/$counter';

  static ChangeNotifierPath? tryParse(RouteInformation ri) {
    final matches = _regExp.firstMatch(ri.location ?? '');
    if (matches == null) return null;

    final counter = int.tryParse(matches[1] ?? '') ?? 0;

    return ChangeNotifierPath(
      counter: counter,
    );
  }

  @override
  List<PagePath> get defaultStackPaths => [
        const HomePath(),
        this,
      ];
}
