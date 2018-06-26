protocol AuthCoordinatorOutput: class {
  // when auth flow finished.
  var finishFlow: (() -> Void)? { get set }
}
