import 'package:flutter/widgets.dart';

import 'page_stacks.dart';
import '../../models/back_pressed_result_enum.dart';

/// The back button dispatcher for [PageStacksBloc],
/// directs requests to the current bloc in the stack.
class PageStacksBackButtonDispatcher extends RootBackButtonDispatcher {
  final PageStacksBloc pageStacksBloc;

  PageStacksBackButtonDispatcher(this.pageStacksBloc);

  @override
  Future<bool> invokeCallback(Future<bool> defaultValue) async {
    final pageStackBloc = pageStacksBloc.currentStackBloc;

    if (pageStackBloc == null) return false; // Not handled, pass further.

    final result = await pageStackBloc.onBackPressed();
    return result == BackPressedResult.keep;
  }
}
