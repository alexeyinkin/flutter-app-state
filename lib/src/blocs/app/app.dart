import 'normalized_state.dart';
import '../page_stack/page_stack.dart';

/// A container for [PageStackBloc] objects.
class AppBloc {
  final _pageStacks = <String, PageStackBloc>{};

  void addPageStack(String key, PageStackBloc bloc) {
    _pageStacks[key] = bloc;
  }

  AppBlocNormalizedState get normalizedState {
    return AppBlocNormalizedState(
      stackStates: _pageStacks.map((k, v) => MapEntry(k, v.normalizedState))
    );
  }

  set normalizedState(AppBlocNormalizedState state) {
    for (final entry in state.stackStates.entries) {
      _pageStacks[entry.key]?.normalizedState = entry.value;
    }
  }
}
