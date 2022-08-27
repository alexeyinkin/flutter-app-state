import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import 'path.dart';

class InputPageNotifier extends ChangeNotifier with PageStateMixin<String> {
  final nameController = TextEditingController();

  InputPageNotifier({
    required String name,
  }) {
    nameController.text = name;
    nameController.addListener(notifyListeners);
  }

  void onSavePressed() {
    pop(nameController.text); // This is statically type-checked to be String.
  }

  bool get canSave => nameController.text != '';

  @override
  InputPath get path => const InputPath();
}
