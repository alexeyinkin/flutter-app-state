import '../page_state/event.dart';
import '../page_state/page_state_mixin.dart';
import '../page_state/path.dart';
import '../pages/abstract.dart';
import 'event.dart';

/// An [PageStackEvent] that carries the [pageEvent] of the specific [page].
class PPageStackPageEvent<C extends PagePath, R> extends PageStackEvent {
  final PAbstractPage<C, R> page;
  final PPageStateMixin<C, R>? state;
  final PageEvent pageEvent;

  PPageStackPageEvent({
    required this.page,
    required this.state,
    required this.pageEvent,
  });
}

typedef PageStackPageEvent<R> = PPageStackPageEvent<PagePath, R>;
