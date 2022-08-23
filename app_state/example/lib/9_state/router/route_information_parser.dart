import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import '../pages/home/path.dart';
import '../pages/bloc/path.dart';
import '../pages/change_notifier/path.dart';
import '../pages/cubit/path.dart';

class MyRouteInformationParser extends PageStackRouteInformationParser {
  @override
  Future<PagePath> parsePagePath(RouteInformation ri) async {
    return BlocPath.tryParse(ri) ??
        ChangeNotifierPath.tryParse(ri) ??
        CubitPath.tryParse(ri) ??
        const HomePath(); // The default page if nothing worked.
  }
}
