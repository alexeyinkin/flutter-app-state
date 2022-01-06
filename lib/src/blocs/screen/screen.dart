import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import 'close_event.dart';
import 'configuration_changed_event.dart';
import 'event.dart';

abstract class ScreenBloc<C, S> {
  final _eventsController = BehaviorSubject<ScreenBlocEvent>();
  Stream<ScreenBlocEvent> get events => _eventsController.stream;

  final _statesController = BehaviorSubject<S>();
  Stream<S> get states => _statesController.stream;

  C? get currentConfiguration;

  @protected
  void emitEvent(ScreenBlocEvent event) {
    _eventsController.sink.add(event);
  }

  @protected
  void emitConfiguration(C configuration) {
    _eventsController.sink.add(
      ScreenBlocConfigurationChangedEvent(
        configuration: configuration,
      ),
    );
  }

  @protected
  void emitCurrentConfiguration() {
    final configuration = currentConfiguration;
    if (configuration == null) throw Exception('currentConfiguration is null');
    emitConfiguration(configuration);
  }

  @protected
  void emitCurrentConfigurationIfAny() {
    final configuration = currentConfiguration;
    if (configuration != null) {
      emitConfiguration(configuration);
    }
  }

  void closeScreen() {
    _eventsController.sink.add(ScreenBlocCloseEvent());
  }

  Future<bool> onBackPressed() => Future.value(false);

  @protected
  void emitState() {
    _statesController.sink.add(createState());
  }

  @protected
  S createState();

  @mustCallSuper
  void dispose() {
    _eventsController.close();
    _statesController.close();
  }
}
