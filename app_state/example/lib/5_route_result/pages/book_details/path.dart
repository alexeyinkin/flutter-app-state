import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import '../../router/tab_enum.dart';
import '../book_list/path.dart';
import 'page.dart';

class BookDetailsPath extends PagePath {
  final int bookId;

  static final _regExp = RegExp(r'^/books/(\d+)$');

  BookDetailsPath({
    required this.bookId,
  }) : super(
          key: BookDetailsPage.formatKey(bookId: bookId),
          factoryKey: BookDetailsPage.classFactoryKey,
          state: {'bookId': bookId},
        );

  @override
  Uri get uri => Uri.parse('/books/$bookId');

  static BookDetailsPath? tryParse(RouteInformation ri) {
    final matches = _regExp.firstMatch(ri.uri.path);
    if (matches == null) return null;

    final bookId = int.tryParse(matches[1] ?? '') ?? (throw Error());
    return BookDetailsPath(
      bookId: bookId,
    );
  }

  @override
  List<PagePath> get defaultStackPaths => [
        const BookListPath(),
        this,
      ];

  @override
  String get defaultStackKey => TabEnum.books.name;
}
