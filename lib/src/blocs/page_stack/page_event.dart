import '../../pages/abstract.dart';
import '../page/bloc.dart';
import '../page/configuration.dart';
import '../page/event.dart';
import 'event.dart';

class PageStackPageBlocEvent<C extends PageConfiguration>
    extends PageStackBlocEvent {
  final AbstractPage<C> page;
  final PageBloc<C>? bloc;
  final PageBlocEvent pageBlocEvent;

  PageStackPageBlocEvent({
    required this.page,
    required this.bloc,
    required this.pageBlocEvent,
  });
}
