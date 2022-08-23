import 'package:app_state/app_state.dart';
import 'package:flutter/material.dart';

import 'path.dart';

class PopupPage extends StatelessMaterialPage {
  static const classFactoryKey = 'Popup';

  PopupPage()
      : super(
          key: const ValueKey(classFactoryKey),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Pop-up'),
            ),
            body: Center(
              child: Text(
                'This can be shown in any tab but prefers Tab 2 when opened by URL',
              ),
            ),
          ),
          path: const PopupPath(),
        );
}
