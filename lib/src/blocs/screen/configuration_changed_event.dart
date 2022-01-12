import 'event.dart';

/// Emit this when configuration of the screen changes.
///
/// The configuration will then be read with [ScreenBloc.currentConfiguration].
class ScreenBlocConfigurationChangedEvent<C> extends ScreenBlocEvent {}
