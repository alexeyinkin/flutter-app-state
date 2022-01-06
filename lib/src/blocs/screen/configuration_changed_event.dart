import 'event.dart';

class ScreenBlocConfigurationChangedEvent<C> extends ScreenBlocEvent {
  final C configuration;

  ScreenBlocConfigurationChangedEvent({
    required this.configuration,
  });
}
