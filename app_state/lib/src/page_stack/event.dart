import '../page_state/path.dart';
import 'page_stack.dart';

/// The base class for [PPageStack] events.
abstract class PPageStackEvent<P extends PagePath> {
  const PPageStackEvent();
}

typedef PageStackEvent = PPageStackEvent<PagePath>;
