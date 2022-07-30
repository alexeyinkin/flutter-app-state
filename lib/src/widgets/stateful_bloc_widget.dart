import 'package:flutter/widgets.dart';

import '../blocs/page/configuration.dart';
import '../blocs/page/stateful_bloc.dart';

abstract class StatefulBlocWidget<
    R,
    B extends CPageStatefulBloc<PageConfiguration, S, R>,
    S> extends StatelessWidget {
  final B bloc;

  const StatefulBlocWidget({
    required this.bloc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<S>(
      stream: bloc.states,
      builder: (context, snapshot) => buildWithState(context, snapshot.data),
    );
  }

  Widget buildWithState(BuildContext context, S? state);
}
