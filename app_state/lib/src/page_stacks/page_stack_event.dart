import '../page_stack/event.dart';
import '../page_stack/page_stack.dart';
import '../page_state/path.dart';
import 'event.dart';

/// A [PageStackEvent] that carries the [pageStackEvent]
/// of the specific [stack].
class PPageStacksStackEvent<P extends PagePath> extends PageStacksEvent {
  final PPageStack<P> stack;
  final PPageStackEvent<P> pageStackEvent;

  PPageStack<P> get bloc => stack;

  PageStackEvent get pageStackBlocEvent => pageStackEvent;

  const PPageStacksStackEvent({
    required this.stack,
    required this.pageStackEvent,
  });
}

typedef PageStacksStackEvent = PPageStacksStackEvent<PagePath>;
