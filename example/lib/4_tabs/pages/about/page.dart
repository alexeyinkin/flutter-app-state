import 'package:app_state/app_state.dart';
import 'package:flutter/material.dart';

import 'path.dart';

class AboutPage extends StatelessMaterialPage {
  static const classFactoryKey = 'About';

  AboutPage() : super(
    key: const ValueKey(classFactoryKey),
    child: Scaffold(appBar: AppBar(title: const Text('About'))),
    path: const AboutPath(),
  );
}
