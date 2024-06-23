import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import '../../router/tab_enum.dart';

class Tab1Path extends PagePath {
  static final _url = Uri.parse('/one');

  const Tab1Path() : super(key: 'Tab1');

  @override
  Uri get uri => _url;

  static Tab1Path? tryParse(RouteInformation ri) {
    return ri.uri == _url ? const Tab1Path() : null;
  }

  @override
  String get defaultStackKey => TabEnum.one.name;
}
