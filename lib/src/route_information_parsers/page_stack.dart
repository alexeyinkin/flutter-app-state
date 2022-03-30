import 'package:flutter/widgets.dart';

import '../blocs/page_stack/configuration.dart';

abstract class PageStackRouteInformationParser extends RouteInformationParser<PageStackConfiguration> {
  @override
  RouteInformation? restoreRouteInformation(PageStackConfiguration configuration) {
    return configuration.getTopPageConfiguration().restoreRouteInformation();
  }
}
