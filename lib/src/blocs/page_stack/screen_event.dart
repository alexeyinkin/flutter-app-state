import 'event.dart';
import '../screen/event.dart';
import '../screen/screen.dart';
import '../../pages/abstract.dart';

class PageStackScreenBlocEvent<C> extends PageStackBlocEvent {
  final AbstractPage<C> page;
  final ScreenBloc<C, dynamic>? bloc;
  final ScreenBlocEvent screenBlocEvent;

  PageStackScreenBlocEvent({
    required this.page,
    required this.bloc,
    required this.screenBlocEvent,
  });
}
