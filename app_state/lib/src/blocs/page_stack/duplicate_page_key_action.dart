/// What to do if pushing a page with a key already existing in the stack.
enum DuplicatePageKeyAction {
  /// Remove and dispose the old page, create a new one on top.
  dropOld,

  /// Dispose the new page without adding, bring the old page to the top.
  bringOld,

  /// Throw an exception.
  error,
}
