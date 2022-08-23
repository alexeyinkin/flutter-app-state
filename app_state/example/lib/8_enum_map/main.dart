import 'package:app_state/app_state.dart';
import 'package:flutter/material.dart';

import 'pages/about/page.dart';
import 'pages/book_list/page.dart';
import 'pages/home/screen.dart';
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
    TabEnum.books.name,
    PageStack(
      bottomPage: BookListPage(),
      createPage: PageFactory.createPage,
    ),
  );

  pageStacks.addPageStack(
    TabEnum.about.name,
    PageStack(
      bottomPage: AboutPage(),
      createPage: PageFactory.createPage,
    ),
  );

  pageStacks.setCurrentStackKey(TabEnum.books.name, fire: false);

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
