import 'package:flutter/widgets.dart';

/// An [Overlay] with a single initial [OverlayEntry].
///
/// Use as a short wrapper to allow tooltips and other popups.
class SingleEntryOverlay extends StatelessWidget {
  final Widget child;

  ///
  const SingleEntryOverlay({required this.child});

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
