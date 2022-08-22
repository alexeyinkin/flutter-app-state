import 'package:app_state/app_state.dart';

import '../../main.dart';
import '../input/page.dart';
import 'path.dart';

class AboutPageBloc extends PageStatefulBloc<AboutPageBlocState, void> {
  String _name;
  final AboutPageBlocState initialState;

  AboutPageBloc({
    required String name,
  }) :
      _name = name,
      initialState = AboutPageBlocState(name: name);

  Future<void> onLicensePressed() async {
    final result = await pageStacks.currentStack?.push(
      InputPage(name: _name),
    );

    print('Awaited: $result');
  }

  @override
  void didPopNext(AbstractPage page, PagePopEvent event) {
    print('didPopNext: ${event.data}');

    final data = event.data;
    if (data is String) {
      _name = data;
      emitState();
    }
  }

  @override
  AboutPageBlocState createState() {
    return AboutPageBlocState(name: _name);
  }

  @override
  AboutPath get path => const AboutPath();
}

class AboutPageBlocState {
  final String name;

  const AboutPageBlocState({
    required this.name,
  });
}
