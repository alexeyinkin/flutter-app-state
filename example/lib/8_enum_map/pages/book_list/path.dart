import 'package:app_state/app_state.dart';

import '../../router/tab_enum.dart';

class BookListPath extends PagePath {
  static const _location = '/books';

  const BookListPath() : super(key: 'BookList');

  @override
  String get location => _location;

  @override
  String get defaultStackKey => TabEnum.books.name;
}
