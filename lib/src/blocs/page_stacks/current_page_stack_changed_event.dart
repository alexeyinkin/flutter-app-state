import 'event.dart';

class CurrentPageStackChangedEvent extends PageStacksBlocEvent {
  final String? oldKey;
  final String? newKey;

  const CurrentPageStackChangedEvent({
    required this.oldKey,
    required this.newKey,
  });
}
