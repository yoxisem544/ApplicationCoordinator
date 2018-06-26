protocol TermsView: BaseView {

  // need a confirmed flag
  var confirmed: Bool { get set }
  // when confirm flag changed
  var onConfirmChanged: ((Bool) -> ())? { get set }
}
