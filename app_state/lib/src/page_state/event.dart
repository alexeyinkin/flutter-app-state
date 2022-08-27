import 'page_state_mixin.dart';

/// The base class for [PPageStateMixin] events.
///
/// Extend this for your custom events like emitting notifications
/// to be shown in overlays etc.
abstract class PageEvent {
  const PageEvent();
}
