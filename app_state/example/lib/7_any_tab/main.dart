import 'package:app_state/app_state.dart';
import 'package:flutter/material.dart';

import 'pages/home/screen.dart';
import 'pages/tab1/page.dart';
import 'pages/tab2/page.dart';
import 'router/page_factory.dart';
import 'router/route_information_parser.dart';
import 'router/tab_enum.dart';

final pageStacks = PageStacks();
final _routerDelegate = MaterialPageStacksRouterDelegate(
  pageStacks,
  child: HomeScreen(stacks: pageStacks),
);
final _routeInformationParser = MyRouteInformationParser();
final _backButtonDispatcher = PageStacksBackButtonDispatcher(pageStacks);

void main() {
  pageStacks.addPageStack(
    TabEnum.one.name,
    PageStack(
      bottomPage: Tab1Page(),
      createPage: PageFactory.createPage,
    ),
  );

  pageStacks.addPageStack(
    TabEnum.two.name,
    PageStack(
      bottomPage: Tab2Page(),
      createPage: PageFactory.createPage,
    ),
  );

  pageStacks.setCurrentStackKey(TabEnum.one.name, fire: false);

  runApp(MyApp());
}

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
