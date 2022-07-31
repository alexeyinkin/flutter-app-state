import '../../pages/abstract.dart';
import '../page/bloc.dart';
import '../page/event.dart';
import '../page/path.dart';
import 'event.dart';

class CPageStackPageBlocEvent<C extends PagePath, R>
    extends PageStackBlocEvent {
  final CAbstractPage<C, R> page;
  final CPageBloc<C, R>? bloc;
  final PageBlocEvent pageBlocEvent;

  CPageStackPageBlocEvent({
    required this.page,
    required this.bloc,
    required this.pageBlocEvent,
  });
}

typedef PageStackPageBlocEvent<R> = CPageStackPageBlocEvent<PagePath, R>;
