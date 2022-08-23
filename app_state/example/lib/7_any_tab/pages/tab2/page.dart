import 'package:app_state/app_state.dart';
import 'package:flutter/material.dart';

import '../../widgets/popup_open_button.dart';
import 'path.dart';

class Tab2Page extends StatelessMaterialPage {
  static const classFactoryKey = 'Tab2';

  Tab2Page()
      : super(
          key: const ValueKey(classFactoryKey),
          child: Scaffold(
            appBar: AppBar(title: const Text('Tab 2')),
            body: Center(
              child: const PopupOpenButton(),
            ),
          ),
          path: const Tab2Path(),
        );
}
