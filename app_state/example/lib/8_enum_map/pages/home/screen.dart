import 'package:app_state/app_state.dart';
import 'package:keyed_collection_widgets/keyed_collection_widgets.dart';
import 'package:flutter/material.dart';

import '../../router/tab_enum.dart';

class HomeScreen extends StatelessWidget {
  final PageStacks stacks;

  const HomeScreen({required this.stacks});

  @override
  Widget build(BuildContext context) {
    return PageStacksBuilder(
      stacks: stacks,
      builder: (BuildContext context) {
        final tab = TabEnum.values.byName(stacks.currentStackKey!);

        return Scaffold(
          body: KeyedStack<TabEnum>(
            itemKey: tab,
            children: UnmodifiableTabEnumMap(
              books: PageStackNavigator(
                key: ValueKey(TabEnum.books),
                stack: stacks.pageStacks[TabEnum.books.name]!,
              ),
              about: PageStackNavigator(
                key: ValueKey(TabEnum.about),
                stack: stacks.pageStacks[TabEnum.about.name]!,
              ),
            ),
          ),
          bottomNavigationBar: KeyedBottomNavigationBar<TabEnum>(
            currentItemKey: tab,
            items: UnmodifiableTabEnumMap(
              books: BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'Books',
              ),
              about: BottomNavigationBarItem(
                icon: Icon(Icons.info),
                label: 'About',
              ),
            ),
            onTap: (tab) => stacks.setCurrentStackKey(tab.name),
          ),
        );
      },
    );
  }
}
