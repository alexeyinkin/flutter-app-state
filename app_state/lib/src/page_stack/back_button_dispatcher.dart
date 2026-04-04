import 'package:flutter/widgets.dart';

import '../models/back_pressed_result_enum.dart';
import 'page_stack.dart';

class PageStackBackButtonDispatcher extends RootBackButtonDispatcher {
  final PageStack pageStack;

  @Deprecated('Use pageStack')
  PageStack get pageStackBloc => pageStack;

  PageStackBackButtonDispatcher(this.pageStack);

  @override
  Future<bool> invokeCallback(Future<bool> defaultValue) async {
    final result = await pageStack.onBackPressed();
    return result == BackPressedResult.keep;
  }
}
