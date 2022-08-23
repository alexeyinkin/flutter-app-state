import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import 'page.dart';
import '../home/path.dart';

class InputPath extends PagePath {
  static const _location = '/input';

  final String text;

  InputPath({
    required this.text,
  }) : super(
          key: 'Input',
          factoryKey: InputPage.classFactoryKey,
          state: {'text': text},
        );

  @override
  get location => _location;

  static InputPath? tryParse(RouteInformation ri) {
    return ri.location == _location ? InputPath(text: '') : null;
  }

  @override
  List<PagePath> get defaultStackPaths => [
        const HomePath(),
        this,
      ];
}
