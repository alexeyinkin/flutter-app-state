import '../page_stack/page_stack_bloc_normalized_state.dart';

/// Used to restore [PageStackBloc] states, can be serialized
/// for browser history.
class AppBlocNormalizedState {
  final Map<String, PageStackBlocNormalizedState> stackStates;

  const AppBlocNormalizedState({
    required this.stackStates,
  });

  const AppBlocNormalizedState.empty() : stackStates = const {};

  static AppBlocNormalizedState? fromMapOrNull(Map<String, dynamic>? map) {
    if (map == null) return null;

    return AppBlocNormalizedState(
      stackStates: PageStackBlocNormalizedState.fromMaps(map['stackStates']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stackStates': stackStates,
    };
  }
}
