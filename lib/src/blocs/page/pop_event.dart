import '../page_stack/bloc.dart';
import 'event.dart';
import 'pop_cause.dart';

/// Emit this for [PageStackBloc] to remove and dispose the page.
///
/// The page could be anywhere in the stack as long as at least one other page
/// is left in the stack afterwards.
class PageBlocPopEvent<R> extends PageBlocEvent {
  final R? data;
  final PopCause cause;

  const PageBlocPopEvent({
    required this.data,
    required this.cause,
  });
}

@Deprecated('Renamed to PageBlocPopEvent')
typedef PageBlocCloseEvent = PageBlocPopEvent;
