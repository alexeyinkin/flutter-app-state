import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import '../pages/home/path.dart';
import '../pages/input/path.dart';

class MyRouteInformationParser extends PageStackRouteInformationParser {
  @override
  Future<PagePath> parsePagePath(RouteInformation ri) async {
    return InputPath.tryParse(ri) ??
        const HomePath(); // The default page if nothing worked.
  }
}
