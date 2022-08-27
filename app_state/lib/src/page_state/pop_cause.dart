import '../page_stack/page_stack.dart';
import 'page_state_mixin.dart';

enum PopCause {
  /// The back button was pressed, and the bloc did not prevent the pop.
  backButton,

  /// The configuration setter removed the page from the stack while applying
  /// a configuration.
  diff,

  /// [PageStateMixin] initiated the pop.
  page,

  /// [PageStack] initiated the pop.
  pageStack,
}
