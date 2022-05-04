import 'package:flutter/widgets.dart';

import '../blocs/page/configuration.dart';
import '../blocs/page/page_stateful.dart';

abstract class StatefulBlocWidget<
    B extends PageStatefulBloc<PageConfiguration, S>,
    S> extends StatelessWidget {
  final B bloc;

  const StatefulBlocWidget({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<S>(
      stream: bloc.states,
      builder: (context, snapshot) => buildWithState(context, snapshot.data),
    );
  }

  Widget buildWithState(BuildContext context, S? state);
}
