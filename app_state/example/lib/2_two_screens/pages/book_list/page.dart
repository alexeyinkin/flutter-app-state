import 'package:app_state/app_state.dart';
import 'package:flutter/foundation.dart';

import 'screen.dart';
import 'state.dart';

class BookListPage extends StatefulMaterialPage<void, BookListState> {
  BookListPage()
      : super(
          key: const ValueKey('BookList'),
          state: BookListState(),
          createScreen: BookListScreen.new,
        );
}
