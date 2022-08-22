import 'package:app_state/app_state.dart';
import 'package:flutter/widgets.dart';

import 'path.dart';

class InputPageBloc extends PageStatefulBloc<InputPageBlocState, String> {
  final nameController = TextEditingController();
  final initialState = InputPageBlocState(canSave: false);

  InputPageBloc({
    required String name,
  }) {
    nameController.text = name;
    nameController.addListener(emitState);
    emitState();
  }

  void onSavePressed() {
    pop(nameController.text);
  }

  @override
  InputPageBlocState createState() {
    return InputPageBlocState(
      canSave: nameController.text != '',
    );
  }

  @override
  InputPath get path => const InputPath();
}

class InputPageBlocState {
  final bool canSave;

  InputPageBlocState({
    required this.canSave,
  });
}
