import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import 'page.dart';
import '../home/path.dart';

class InputPath extends PagePath {
  static final _url = Uri.parse('/input');

  final String text;

  InputPath({
    required this.text,
  }) : super(
          key: 'Input',
          factoryKey: InputPage.classFactoryKey,
          state: {'text': text},
        );

  @override
  Uri get uri => _url;

  static InputPath? tryParse(RouteInformation ri) {
    return ri.uri == _url ? InputPath(text: '') : null;
  }

  @override
  List<PagePath> get defaultStackPaths => [
        const HomePath(),
        this,
      ];
}
