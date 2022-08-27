import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import '../../main.dart';
import '../input/page.dart';
import 'path.dart';

class AboutPageNotifier extends ChangeNotifier with PageStateMixin<void> {
  String name;

  AboutPageNotifier({required this.name});

  Future<void> onLicensePressed() async {
    // This is statically type-checked to be String.
    final result = await pageStacks.currentStack?.push(
      InputPage(name: name),
    );

    print('Awaited: $result');
  }

  @override
  void didPopNext(AbstractPage page, PagePopEvent event) {
    print('didPopNext: ${event.data}');

    final data = event.data; // Not type-checked in any way.
    if (data is String) {
      name = data;
      notifyListeners();
    }
  }

  @override
  AboutPath get path => const AboutPath();
}
