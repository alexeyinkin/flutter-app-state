import 'event.dart';

/// Emit this when configuration of the screen changes.
///
/// The configuration will then be read with [PageBloc.currentConfiguration].
class PageBlocConfigurationChangedEvent extends PageBlocEvent {}
