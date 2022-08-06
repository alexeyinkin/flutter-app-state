import 'dart:async';

import 'package:app_state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'common.mocks.dart';

@GenerateMocks([CPageBloc])
class _MyGenerateMocks {}

class HomePath extends PagePath {
  static const _location = '/';

  const HomePath()
      : super(
          key: HomePage.classFactoryKey,
        );

  static PagePath? tryParse(RouteInformation ri) {
    return ri.location == _location ? const HomePath() : null;
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
  static const _location = '/books';

  final String? category;

  BooksStatefulPath({this.category})
      : super(
            key: BooksStatefulPage.classFactoryKey,
            state: {'category': category});

  static PagePath? tryParse(RouteInformation ri) {
    return ri.location == _location ? BooksStatefulPath() : null;
  }

  @override
  List<PagePath> get defaultStackPaths => [
        const HomePath(),
        this,
      ];
}

class BooksStatefulPage
    extends BlocMaterialPage<dynamic, BooksStatefulPageBloc> {
  static const classFactoryKey = 'Books';

  BooksStatefulPage()
      : super(
          bloc: BooksStatefulPageBloc(),
          key: const ValueKey(classFactoryKey),
          createScreen: (b) => Text('$classFactoryKey-${b.category}'),
        );
}

class BooksStatefulPageBloc extends PageBloc {
  String? category;
  BackPressedResult backPressedResult = BackPressedResult.close;

  BooksStatefulPageBloc({
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
  String get location => '/books/$id';

  static BookPath? tryParse(RouteInformation ri) {
    final matches = _regExp.firstMatch(ri.location ?? '');
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
  static const _location = '/home';

  const AltHomePath()
      : super(
          key: AltHomePage.classFactoryKey,
        );

  static PagePath? tryParse(RouteInformation ri) {
    return ri.location == _location ? const AltHomePath() : null;
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

class TestPageBlocEvent extends PageBlocEvent {
  const TestPageBlocEvent();
}

PageBloc<R> mockPageBloc<R>() {
  final result = MockCPageBloc<PagePath, R>();
  when(result.events)
      .thenAnswer((_) => StreamController<PageBlocEvent>().stream);
  return result;
}

BlocMaterialPage createBlocPage(CPageBloc bloc) {
  return CBlocMaterialPage(bloc: bloc, createScreen: (b) => Text('$b'));
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
