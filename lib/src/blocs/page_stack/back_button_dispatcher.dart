import 'package:flutter/widgets.dart';

import '../../models/back_pressed_result_enum.dart';
import 'bloc.dart';

class PageStackBackButtonDispatcher extends RootBackButtonDispatcher {
  final PageStackBloc pageStackBloc;

  PageStackBackButtonDispatcher(this.pageStackBloc);

  @override
  Future<bool> invokeCallback(Future<bool> defaultValue) async {
    final result = await pageStackBloc.onBackPressed();
    return result == BackPressedResult.keep;
  }
}
