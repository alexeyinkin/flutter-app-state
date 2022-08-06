enum PopCause {
  /// The back button was pressed, and the bloc did not prevent the pop.
  backButton,

  /// The configuration setter removed the page from the stack while applying
  /// a configuration.
  diff,

  /// The bloc initiated the pop.
  bloc,
}
