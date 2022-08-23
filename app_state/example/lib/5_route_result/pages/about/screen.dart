import 'package:flutter/material.dart';

import 'state.dart';

class AboutScreen extends StatelessWidget {
  final AboutPageBloc bloc;

  const AboutScreen({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AboutPageBlocState>(
      stream: bloc.states,
      builder: (context, snapshot) =>
          _buildWithState(snapshot.data ?? bloc.initialState),
    );
  }

  Widget _buildWithState(AboutPageBlocState state) {
    final text = state.name == ''
        ? 'This software is not licensed.'
        : 'This software is licensed to ${state.name}.';

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(text),
            Container(height: 20),
            ElevatedButton(
              child: const Text('License'),
              onPressed: bloc.onLicensePressed,
            ),
          ],
        ),
      ),
    );
  }
}
