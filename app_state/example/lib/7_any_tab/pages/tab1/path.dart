import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import '../../router/tab_enum.dart';

class Tab1Path extends PagePath {
  static const _location = '/one';

  const Tab1Path() : super(key: 'Tab1');

  @override
  String get location => _location;

  static Tab1Path? tryParse(RouteInformation ri) {
    return ri.location == _location ? const Tab1Path() : null;
  }

  @override
  String get defaultStackKey => TabEnum.one.name;
}
