import 'package:app_state/app_state.dart';
import 'package:flutter/material.dart';

import 'bloc.dart';
import 'screen.dart';

class AboutPage extends StatefulMaterialPage<void, AboutPageBloc> {
  static const classFactoryKey = 'About';

  AboutPage() : super(
    key: const ValueKey(classFactoryKey),
    state: AboutPageBloc(name: ''),
    createScreen: (b) => AboutScreen(bloc: b),
  );
}
