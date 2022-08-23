import 'package:meta/meta.dart';

import 'page_state_mixin.dart';
import 'path.dart';

/// The default implementation of [PPageStateMixin].
///
/// Use this when you need this mixin to emit page events but have no state.
///
/// This is a stub that you only use if you do not need to create your own
/// class. The moment you need your own class, do not extend this
/// but create anything `with` [PPageStateMixin].
///
/// Do not use this class in interfaces because this will make switching
/// to other classes harder when you get to need custom states.
@sealed
class PPageState<P extends PagePath, R> with PPageStateMixin<P, R> {}

typedef PageState<R> = PPageState<PagePath, R>;
