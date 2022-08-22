import '../page/path.dart';
import 'page_stack.dart';

/// The base class for [PPageStack] events.
abstract class PPageStackEvent<P extends PagePath> {
  const PPageStackEvent();
}

typedef PageStackEvent = PPageStackEvent<PagePath>;

@Deprecated('Renamed to PageStackEvent in v0.7.0')
typedef PageStackBlocEvent = PageStackEvent;
