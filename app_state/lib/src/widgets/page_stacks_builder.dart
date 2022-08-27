import 'package:flutter/widgets.dart';

import '../page_stacks/page_stacks.dart';

/// Widget that builds itself when [stacks] emits events.
class PageStacksBuilder extends StatelessWidget {
  final PageStacks stacks;
  final WidgetBuilder builder;

  ///
  const PageStacksBuilder({
    super.key,
    required this.stacks,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stacks.events,
      builder: (context, snapshot) => builder(context),
    );
  }
}
