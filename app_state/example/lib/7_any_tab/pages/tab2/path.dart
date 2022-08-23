import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import '../../router/tab_enum.dart';

class Tab2Path extends PagePath {
  static const _location = '/two';

  const Tab2Path() : super(key: 'Tab2');

  @override
  String get location => _location;

  static Tab2Path? tryParse(RouteInformation ri) {
    return ri.location == _location ? const Tab2Path() : null;
  }

  @override
  String get defaultStackKey => TabEnum.two.name;
}
