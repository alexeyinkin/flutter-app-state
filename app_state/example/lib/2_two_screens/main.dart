import 'package:app_state/app_state.dart';
import 'package:flutter/material.dart';

import 'pages/book_list/page.dart';

final pageStack = PageStack(bottomPage: BookListPage());
final _routerDelegate = PageStackRouterDelegate(pageStack);
final _backButtonDispatcher = PageStackBackButtonDispatcher(pageStack);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _routerDelegate,
      routeInformationParser: const PageStackRouteInformationParser(),
      backButtonDispatcher: _backButtonDispatcher,
    );
  }
}
