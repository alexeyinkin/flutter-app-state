import '../page_stack/bloc.dart';
import 'bloc.dart';

enum PopCause {
  /// The back button was pressed, and the bloc did not prevent the pop.
  backButton,

  /// The configuration setter removed the page from the stack while applying
  /// a configuration.
  diff,

  /// [PageBloc] initiated the pop.
  pageBloc,

  /// [PageStackBloc] initiated the pop.
  pageStackBloc,
}
