import 'package:app_state/app_state.dart';

import '../../router/tab_enum.dart';

class BookListPath extends PagePath {
  static final _url = Uri.parse('/books');

  const BookListPath() : super(key: 'BookList');

  @override
  Uri get uri => _url;

  @override
  String get defaultStackKey => TabEnum.books.name;
}
