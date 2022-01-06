import 'package:flutter/widgets.dart';

import 'page_stack.dart';

class PageStackBackButtonDispatcher extends RootBackButtonDispatcher {
  final PageStackBloc pageStackBloc;

  PageStackBackButtonDispatcher(this.pageStackBloc);

  @override
  Future<bool> invokeCallback(Future<bool> defaultValue) {
    return pageStackBloc.onBackPressed();
  }
}
