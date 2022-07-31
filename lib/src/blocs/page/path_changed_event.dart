import 'bloc.dart';
import 'event.dart';
import 'path.dart';

/// Emit this when the path of the screen changes (location or state).
///
/// The [PagePath] will then be read with [CPageBloc.path].
class PageBlocPathChangedEvent extends PageBlocEvent {
  const PageBlocPathChangedEvent();
}
