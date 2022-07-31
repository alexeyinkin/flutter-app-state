import '../page/path.dart';
import '../page_stack/bloc.dart';
import '../page_stack/event.dart';
import 'event.dart';

class CPageStacksPageStackBlocEvent<P extends PagePath>
    extends PageStacksBlocEvent {
  final CPageStackBloc<P> bloc;
  final PageStackBlocEvent pageStackBlocEvent;

  const CPageStacksPageStackBlocEvent({
    required this.bloc,
    required this.pageStackBlocEvent,
  });
}

typedef PageStacksPageStackBlocEvent = CPageStacksPageStackBlocEvent<PagePath>;
