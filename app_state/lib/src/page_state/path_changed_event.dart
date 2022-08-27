import 'event.dart';
import 'page_state_mixin.dart';
import 'path.dart';

/// Emit this when the path of the screen changes (location or state).
///
/// The [PagePath] will then be read with [PPageStateMixin.path].
class PagePathChangedEvent extends PageEvent {
  const PagePathChangedEvent();
}
