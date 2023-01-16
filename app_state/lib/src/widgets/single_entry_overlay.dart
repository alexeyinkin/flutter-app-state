import 'package:flutter/widgets.dart';

class SingleEntryOverlay extends StatelessWidget {
  const SingleEntryOverlay({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) => child,
        ),
      ],
    );
  }
}
