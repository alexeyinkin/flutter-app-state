import '../../pages/abstract.dart';
import '../page/path.dart';
import 'bloc.dart';

/// How to match [CAbstractPage] objects with [PagePath] objects
/// in [CPageStackBloc].`setConfiguration` and `replacePath`.
enum PageStackMatchMode {
  /// Do not attempt to match. Replace all pages.
  none,

  /// Match page.key with path.key. `path.key == null` matches anything.
  /// No gap is allowed while diffing. If one of the stacks contains
  /// an extra page after which the stacks match again, that mismatch
  /// ends the diffing, and pages are replaced from that position on.
  keyOrNullPathNoGap,
}
