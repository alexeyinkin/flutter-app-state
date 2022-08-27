import 'package:flutter/widgets.dart';

import '../models/back_pressed_result_enum.dart';
import 'page_stack.dart';

class PageStackBackButtonDispatcher extends RootBackButtonDispatcher {
  final PageStack pageStack;

  PageStack get pageStackBloc => pageStack;

  PageStackBackButtonDispatcher(this.pageStack);

  @override
  Future<bool> invokeCallback(Future<bool> defaultValue) async {
    final result = await pageStackBloc.onBackPressed();
    return result == BackPressedResult.keep;
  }
}
