import 'package:flutter/material.dart';

import '../../book_repository.dart';
import 'state.dart';

class BookListScreen extends StatelessWidget {
  final BookListState state;

  const BookListScreen(this.state);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        children: [
          for (final book in bookRepository)
            ListTile(
              title: Text(book.title),
              subtitle: Text(book.author),
              onTap: () => state.showDetails(book),
            ),
        ],
      ),
    );
  }
}
