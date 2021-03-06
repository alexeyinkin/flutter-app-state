import '../page_stack/bloc.dart';
import 'event.dart';

/// Emit this for [PageStackBloc] to remove and dispose the page.
///
/// The page could be anywhere in the stack as long as at least one other page
/// is left in the stack afterwards.
class PageBlocCloseEvent<R> extends PageBlocEvent {
  final R? data;

  const PageBlocCloseEvent({
    required this.data,
  });
}
