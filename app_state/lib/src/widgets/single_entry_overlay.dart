import 'package:flutter/widgets.dart';

/// Widget for cases where the parent should be [Overlay]
/// For example: to use in your own [RouterDelegate]
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
