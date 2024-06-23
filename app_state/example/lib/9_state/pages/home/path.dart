import 'package:app_state/app_state.dart';

class HomePath extends PagePath {
  static final _url = Uri.parse('/');

  const HomePath() : super(key: 'Home');

  @override
  Uri get uri => _url;
}
