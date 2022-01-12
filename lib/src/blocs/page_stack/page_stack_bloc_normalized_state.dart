import 'screen_bloc_normalized_state.dart';

/// Used to recover [ScreenBlocNormalizedState] objects, can be serialized
/// for browser history.
class PageStackBlocNormalizedState {
  final List<ScreenBlocNormalizedState> screenStates;

  PageStackBlocNormalizedState({
    required this.screenStates,
  });

  static Map<String, PageStackBlocNormalizedState> fromMaps(Map<String, dynamic> maps) {
    return maps
        .cast<String, Map<String, dynamic>>()
        .map(
          (k, v) => MapEntry(k, PageStackBlocNormalizedState._fromMap(v)),
        );
  }

  factory PageStackBlocNormalizedState._fromMap(Map<String, dynamic> map) {
    return PageStackBlocNormalizedState(
      screenStates: ScreenBlocNormalizedState.fromMaps(map['screenStates']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'screenStates': screenStates,
    };
  }
}
