import '../../pages/abstract.dart';
import '../page/event.dart';
import '../page/page_state_mixin.dart';
import '../page/path.dart';
import 'event.dart';

/// An [PageStackEvent] that carries the [pageEvent] of the specific [page].
class PPageStackPageEvent<C extends PagePath, R> extends PageStackEvent {
  final PAbstractPage<C, R> page;
  final PPageStateMixin<C, R>? state;
  final PageEvent pageEvent;

  @Deprecated('Renamed to state in v0.7.0')
  PPageStateMixin<C, R>? get bloc => state;

  @Deprecated('Renamed to state in v0.7.0')
  PageEvent get pageBlocEvent => pageEvent;

  PPageStackPageEvent({
    required this.page,
    required this.state,
    required this.pageEvent,
  });
}

typedef PageStackPageEvent<R> = PPageStackPageEvent<PagePath, R>;

@Deprecated('Renamed to PageStackPageEvent in v0.7.0')
typedef PageStackPageBlocEvent<R> = PPageStackPageEvent<PagePath, R>;

@Deprecated('Renamed to PPageStackPageEvent in v0.7.0')
typedef CPageStackPageBlocEvent<P extends PagePath, R>
    = PPageStackPageEvent<P, R>;
