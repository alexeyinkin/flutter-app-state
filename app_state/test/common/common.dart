import 'dart:async';

import 'package:app_state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'common.mocks.dart';

@GenerateMocks([PPageState])
class _MyGenerateMocks {} // ignore: unused_element

class HomePath extends PagePath {
  static final _url = Uri.parse('/');

  const HomePath()
      : super(
          key: HomePage.classFactoryKey,
        );

  static PagePath? tryParse(RouteInformation ri) {
    return ri.uri == _url ? const HomePath() : null;
  }
}

class HomePage extends StatelessMaterialPage {
  static const classFactoryKey = 'Home';

  HomePage()
      : super(
          key: const ValueKey(classFactoryKey),
          child: Container(),
          path: const HomePath(),
        );
}

class BooksStatefulPath extends PagePath {
  static final _url = Uri.parse('/books');

  final String? category;

  BooksStatefulPath({this.category})
      : super(
          key: BooksStatefulPage.classFactoryKey,
          state: {'category': category},
        );

  static PagePath? tryParse(RouteInformation ri) {
    return ri.uri == _url ? BooksStatefulPath() : null;
  }

  @override
  List<PagePath> get defaultStackPaths => [
        const HomePath(),
        this,
      ];
}

class BooksStatefulPage
    extends StatefulMaterialPage<dynamic, BooksStatefulPageState> {
  static const classFactoryKey = 'Books';

  BooksStatefulPage()
      : super(
          state: BooksStatefulPageState(),
          key: const ValueKey(classFactoryKey),
          createScreen: (b) => Text('$classFactoryKey-${b.category}'),
        );
}

class BooksStatefulPageState with PageStateMixin {
  String? category;
  BackPressedResult backPressedResult = BackPressedResult.close;

  BooksStatefulPageState({
    this.category,
  });

  @override
  void setStateMap(Map<String, dynamic> state) {
    category = state['category'];
  }

  @override
  Future<BackPressedResult> onBackPressed() => Future.value(backPressedResult);
}

class BookPath extends PagePath {
  final int id;

  static final _regExp = RegExp(r'^/books/(\d+)$');

  BookPath({required this.id})
      : super(
          key: BookPage.formatKey(id: id),
          factoryKey: BookPage.classFactoryKey,
          state: {'id': id},
        );

  @override
  Uri get uri => Uri.parse('/books/$id');

  static BookPath? tryParse(RouteInformation ri) {
    final matches = _regExp.firstMatch(ri.uri.path);
    if (matches == null) return null;

    final id = int.tryParse(matches[1] ?? '');

    if (id == null) {
      return null; // Will never get here with present _regExp.
    }

    return BookPath(
      id: id,
    );
  }

  @override
  List<PagePath> get defaultStackPaths => [
        const HomePath(),
        BooksStatefulPath(),
        this,
      ];
}

class BookPage extends StatelessMaterialPage {
  final int id;
  static const classFactoryKey = 'Book';

  BookPage({required this.id})
      : super(
          key: ValueKey(formatKey(id: id)),
          factoryKey: classFactoryKey,
          path: BookPath(id: id),
          child: Text(formatKey(id: id)),
        );

  static String formatKey({required int id}) => '$classFactoryKey-$id';
}

class AltHomePath extends PagePath {
  static final _url = Uri.parse('/home');

  const AltHomePath()
      : super(
          key: AltHomePage.classFactoryKey,
        );

  static PagePath? tryParse(RouteInformation ri) {
    return ri.uri == _url ? const AltHomePath() : null;
  }
}

class AltHomePage extends StatelessMaterialPage {
  static const classFactoryKey = 'AltHomePage';

  AltHomePage()
      : super(
          key: const ValueKey(classFactoryKey),
          child: const Text(classFactoryKey),
          path: const AltHomePath(),
        );
}

class TestPageEvent extends PageEvent {
  const TestPageEvent();
}

PageStateMixin<R> mockPageState<R>() {
  final result = MockPPageState<PagePath, R>();
  when(result.events).thenAnswer((_) => StreamController<PageEvent>().stream);
  return result;
}

PStatefulMaterialPage createStatefulPage(PPageStateMixin state) {
  return PStatefulMaterialPage(state: state, createScreen: (b) => Text('$b'));
}

class CommonPageStackRouteInformationParser
    extends PageStackRouteInformationParser {
  @override
  Future<PagePath> parsePagePath(RouteInformation ri) async {
    return AltHomePath.tryParse(ri) ??
        BookPath.tryParse(ri) ??
        BooksStatefulPath.tryParse(ri) ??
        const HomePath();
  }
}

class CommonPageFactory {
  static AbstractPage createPage(
    String factoryKey,
    Map<String, dynamic> state,
  ) {
    switch (factoryKey) {
      case AltHomePage.classFactoryKey:
        return AltHomePage();
      case BooksStatefulPage.classFactoryKey:
        return BooksStatefulPage();
      case BookPage.classFactoryKey:
        return BookPage(id: state['id']);
      case HomePage.classFactoryKey:
        return HomePage();
    }

    throw Exception('Cannot create $factoryKey page');
  }
}
