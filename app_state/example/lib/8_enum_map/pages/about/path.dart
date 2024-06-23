import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import '../../router/tab_enum.dart';
import 'page.dart';

class AboutPath extends PagePath {
  static final _url = Uri.parse('/about');

  const AboutPath() : super(key: AboutPage.classFactoryKey);

  @override
  Uri get uri => _url;

  static AboutPath? tryParse(RouteInformation ri) {
    return ri.uri == _url ? const AboutPath() : null;
  }

  @override
  String get defaultStackKey => TabEnum.about.name;
}
