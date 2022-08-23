import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import '../../router/tab_enum.dart';
import '../tab2/path.dart';

class PopupPath extends PagePath {
  static const _location = '/popup';

  const PopupPath() : super(key: 'Popup');

  @override
  String get location => _location;

  static PopupPath? tryParse(RouteInformation ri) {
    return ri.location == _location ? const PopupPath() : null;
  }

  @override
  List<PagePath> get defaultStackPaths => [
        const Tab2Path(),
        this,
      ];

  @override
  String get defaultStackKey => TabEnum.two.name;
}
