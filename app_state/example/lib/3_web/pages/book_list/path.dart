import 'package:app_state/app_state.dart';

class BookListPath extends PagePath {
  static const _location = '/books';

  const BookListPath() : super(key: 'BookList');

  @override
  String get location => _location;
}
