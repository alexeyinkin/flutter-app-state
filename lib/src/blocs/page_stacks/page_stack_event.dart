import '../page/configuration.dart';
import '../page_stack/bloc.dart';
import '../page_stack/event.dart';
import 'event.dart';

class PageStacksPageStackBlocEvent<C extends PageConfiguration>
    extends PageStacksBlocEvent {
  final PageStackBloc<C> bloc;
  final PageStackBlocEvent pageStackBlocEvent;

  const PageStacksPageStackBlocEvent({
    required this.bloc,
    required this.pageStackBlocEvent,
  });
}
