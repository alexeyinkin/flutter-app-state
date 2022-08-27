import 'package:app_state/app_state.dart';
import 'package:flutter/material.dart';

import 'screen.dart';
import 'state.dart';

class AboutPage extends StatefulMaterialPage<void, AboutPageNotifier> {
  static const classFactoryKey = 'About';

  AboutPage()
      : super(
          key: const ValueKey(classFactoryKey),
          state: AboutPageNotifier(name: ''),
          createScreen: AboutScreen.new,
        );
}
