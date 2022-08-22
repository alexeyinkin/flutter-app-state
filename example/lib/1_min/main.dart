import 'package:app_state/app_state.dart';
import 'package:flutter/material.dart';

final pageStack = PageStack(bottomPage: HomePage());
final _routerDelegate = PageStackRouterDelegate(pageStack);

void main() => runApp(MyApp());

class HomePage extends StatelessMaterialPage {
  HomePage() : super(key: const ValueKey('Home'), child: HomeScreen());
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hello World with app_state!')),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _routerDelegate,
      routeInformationParser: const PageStackRouteInformationParser(),
    );
  }
}
