import 'event.dart';
import '../page/configuration.dart';
import '../page/event.dart';
import '../page/page.dart';
import '../../pages/abstract.dart';

class PageStackPageBlocEvent<C extends PageConfiguration> extends PageStackBlocEvent {
  final AbstractPage<C> page;
  final PageBloc<C>? bloc;
  final PageBlocEvent pageBlocEvent;

  PageStackPageBlocEvent({
    required this.page,
    required this.bloc,
    required this.pageBlocEvent,
  });
}
