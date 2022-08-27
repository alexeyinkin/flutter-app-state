import 'package:flutter/widgets.dart';

import '../models/back_pressed_result_enum.dart';
import 'page_stacks.dart';

/// The back button dispatcher for [PageStacks],
/// directs requests to the current bloc in the stack.
class PageStacksBackButtonDispatcher extends RootBackButtonDispatcher {
  final PageStacks pageStacks;

  PageStacksBackButtonDispatcher(this.pageStacks);

  @override
  Future<bool> invokeCallback(Future<bool> defaultValue) async {
    final stack = pageStacks.currentStack;

    if (stack == null) {
      return false; // Not handled, pass farther.
    }

    final result = await stack.onBackPressed();
    return result == BackPressedResult.keep;
  }
}
