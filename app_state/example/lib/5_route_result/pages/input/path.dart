import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import '../../router/tab_enum.dart';
import '../about/path.dart';

class InputPath extends PagePath {
  static const _location = '/input';

  const InputPath() : super(key: 'Input');

  @override
  String get location => _location;

  static InputPath? tryParse(RouteInformation ri) {
    return ri.location == _location ? const InputPath() : null;
  }

  @override
  get defaultStackPaths => [
        const AboutPath(),
        this,
      ];

  @override
  String get defaultStackKey => TabEnum.about.name;
}
