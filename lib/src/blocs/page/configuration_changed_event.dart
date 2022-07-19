import 'bloc.dart';
import 'event.dart';

/// Emit this when configuration of the screen changes.
///
/// The configuration will then be read with [PageBloc.getConfiguration].
class PageBlocConfigurationChangedEvent extends PageBlocEvent {
  const PageBlocConfigurationChangedEvent();
}
