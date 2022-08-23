import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import '../pages/popup/path.dart';
import '../pages/tab1/path.dart';
import '../pages/tab2/path.dart';

class MyRouteInformationParser extends PageStacksRouteInformationParser {
  @override
  Future<PagePath> parsePagePath(RouteInformation ri) async {
    return PopupPath.tryParse(ri) ??
        Tab2Path.tryParse(ri) ??
        const Tab1Path(); // The default page if nothing worked.
  }
}
