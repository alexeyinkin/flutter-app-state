import 'package:flutter/material.dart';

import '../main.dart';
import '../pages/popup/page.dart';

class PopupOpenButton extends StatelessWidget {
  const PopupOpenButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        pageStacks.currentStack?.push(PopupPage());
      },
      child: const Text('Open Pop-up'),
    );
  }
}
