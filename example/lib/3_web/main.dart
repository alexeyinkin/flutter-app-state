import 'package:app_state/app_state.dart';
import 'package:flutter/material.dart';

import 'pages/book_list/page.dart';
import 'router/page_factory.dart';
import 'router/route_information_parser.dart';

final pageStack = PageStack(
  bottomPage: BookListPage(),
  createPage: PageFactory.createPage,
);
final _routerDelegate = PageStackRouterDelegate(pageStack);
final _routeInformationParser = MyRouteInformationParser();
final _backButtonDispatcher = PageStackBackButtonDispatcher(pageStack);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
      backButtonDispatcher: _backButtonDispatcher,
    );
  }
}
