import 'package:flutter/material.dart';

import 'bloc.dart';

class InputScreen extends StatelessWidget {
  final InputPageBloc bloc;

  const InputScreen(this.bloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<InputPageBlocState>(
      stream: bloc.states,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? bloc.initialState),
    );
  }

  Widget _buildWithState(InputPageBlocState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Your Name')),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: bloc.nameController,
              decoration: const InputDecoration(
                label: Text('Name'),
              ),
            ),
            Container(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: bloc.pop,
                ),
                Container(width: 20),
                ElevatedButton(
                  child: const Text('Save'),
                  onPressed: bloc.onSavePressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
