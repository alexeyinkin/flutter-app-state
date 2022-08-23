import 'package:app_state/app_state.dart';

import '../../main.dart';
import '../../models/book.dart';
import '../book_details/page.dart';
import 'path.dart';

class BookListState with PageStateMixin<void> {
  void showDetails(Book book) {
    pageStacks.currentStack?.push(BookDetailsPage(bookId: book.id));
  }

  @override
  BookListPath get path => const BookListPath();
}
