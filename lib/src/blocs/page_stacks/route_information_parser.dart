import 'package:flutter/widgets.dart';

import 'configuration.dart';

abstract class PageStacksRouteInformationParser
    extends RouteInformationParser<PageStacksConfiguration> {
  @override
  RouteInformation? restoreRouteInformation(
    PageStacksConfiguration configuration,
  ) {
    return configuration.currentStackConfiguration
        ?.getTopPageConfiguration()
        .restoreRouteInformation();
  }
}
