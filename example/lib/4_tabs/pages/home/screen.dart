import 'package:app_state/app_state.dart';
import 'package:keyed_collection_widgets/keyed_collection_widgets.dart';
import 'package:flutter/material.dart';

import '../../router/tab_enum.dart';

class HomeScreen extends StatelessWidget {
  final PageStacks stacks;

  const HomeScreen({required this.stacks});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stacks.events,
      builder: (context, snapshot) => _buildOnEvent(),
    );
  }

  Widget _buildOnEvent() {
    final tab = TabEnum.values.byName(stacks.currentStackKey!);

    return Scaffold(
      body: KeyedStack<TabEnum>(
        itemKey: tab,
        children: stacks.pageStacks.map((tabString, bloc) => MapEntry(
          TabEnum.values.byName(tabString),
          PageStackNavigator(key: ValueKey(tabString), stack: bloc)),
        ),
      ),
      bottomNavigationBar: KeyedBottomNavigationBar<TabEnum>(
        currentItemKey: tab,
        items: const {
          TabEnum.books: BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Books',
          ),
          TabEnum.about: BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        },
        onTap: (tab) => stacks.setCurrentStackKey(tab.name),
      ),
    );
  }
}
