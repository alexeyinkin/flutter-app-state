import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import '../pages/book_details/path.dart';
import '../pages/book_list/path.dart';

class MyRouteInformationParser extends PageStackRouteInformationParser {
  @override
  Future<PagePath> parsePagePath(RouteInformation ri) async {
    return BookDetailsPath.tryParse(ri) ??
        const BookListPath(); // The default page if nothing worked.
  }
}
