/// Used to recover [ScreenBloc] state, can be serialized for browser history.
class ScreenBlocNormalizedState {
  final String pageKey;
  final Map<String, dynamic> state;

  ScreenBlocNormalizedState({
    required this.pageKey,
    required this.state,
  });

  static List<ScreenBlocNormalizedState> fromMaps(List maps) {
    return maps
        .cast<Map<String, dynamic>>()
        .map((v) => ScreenBlocNormalizedState._fromMap(v))
        .toList(growable: false);
  }

  factory ScreenBlocNormalizedState._fromMap(Map<String, dynamic> map) {
    return ScreenBlocNormalizedState(
      pageKey: map['pageType'],
      state: map['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageType': pageKey,
      'state': state,
    };
  }
}
