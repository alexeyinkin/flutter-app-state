import '../page_stack/page_stack.dart';
import 'event.dart';
import 'pop_cause.dart';

/// Emit this for [PageStack] to remove and dispose the page.
///
/// The page could be anywhere in the stack as long as at least one other page
/// is left in the stack afterwards.
class PagePopEvent<R> extends PageEvent {
  final R? data;
  final PopCause cause;

  const PagePopEvent({
    required this.data,
    required this.cause,
  });
}
