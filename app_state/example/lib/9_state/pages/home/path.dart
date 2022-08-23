import 'package:app_state/app_state.dart';

class HomePath extends PagePath {
  static const _location = '/';

  const HomePath() : super(key: 'Home');

  @override
  String get location => _location;
}
