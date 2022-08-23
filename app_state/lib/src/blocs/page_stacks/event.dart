import 'page_stacks.dart';

/// The base class for [PageStacks] events.
abstract class PageStacksEvent {
  const PageStacksEvent();
}

@Deprecated('Renamed to PageStacksEvent in v0.7.0')
typedef PageStacksBlocEvent = PageStacksEvent;
