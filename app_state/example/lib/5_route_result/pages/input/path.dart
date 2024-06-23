import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import '../../router/tab_enum.dart';
import '../about/path.dart';

class InputPath extends PagePath {
  static final _url = Uri.parse('/input');

  const InputPath() : super(key: 'Input');

  @override
  Uri get uri => _url;

  static InputPath? tryParse(RouteInformation ri) {
    return ri.uri == _url ? const InputPath() : null;
  }

  @override
  get defaultStackPaths => [
        const AboutPath(),
        this,
      ];

  @override
  String get defaultStackKey => TabEnum.about.name;
}
