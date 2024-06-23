import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import '../../router/tab_enum.dart';
import '../tab2/path.dart';

class PopupPath extends PagePath {
  static final _url = Uri.parse('/popup');

  const PopupPath() : super(key: 'Popup');

  @override
  Uri get uri => _url;

  static PopupPath? tryParse(RouteInformation ri) {
    return ri.uri == _url ? const PopupPath() : null;
  }

  @override
  List<PagePath> get defaultStackPaths => [
        const Tab2Path(),
        this,
      ];

  @override
  String get defaultStackKey => TabEnum.two.name;
}
