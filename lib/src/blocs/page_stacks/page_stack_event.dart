import '../page/configuration.dart';
import '../page_stack/bloc.dart';
import '../page_stack/event.dart';
import 'event.dart';

class CPageStacksPageStackBlocEvent<C extends PageConfiguration>
    extends PageStacksBlocEvent {
  final CPageStackBloc<C> bloc;
  final PageStackBlocEvent pageStackBlocEvent;

  const CPageStacksPageStackBlocEvent({
    required this.bloc,
    required this.pageStackBlocEvent,
  });
}

typedef PageStacksPageStackBlocEvent
    = CPageStacksPageStackBlocEvent<PageConfiguration>;
