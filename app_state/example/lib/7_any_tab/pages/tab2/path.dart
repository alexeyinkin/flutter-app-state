import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import '../../router/tab_enum.dart';

class Tab2Path extends PagePath {
  static final _url = Uri.parse('/two');

  const Tab2Path() : super(key: 'Tab2');

  @override
  Uri get uri => _url;

  static Tab2Path? tryParse(RouteInformation ri) {
    return ri.uri == _url ? const Tab2Path() : null;
  }

  @override
  String get defaultStackKey => TabEnum.two.name;
}
