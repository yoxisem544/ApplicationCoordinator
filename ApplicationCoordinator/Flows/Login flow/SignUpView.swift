protocol SignUpView: BaseView {

  // terms confirmed flag
  var confirmed: Bool { get set }
  // after terms confirmed, then sign up button tapped
  var onSignUpComplete: (() -> Void)? { get set }
  var onTermsButtonTap: (() -> Void)? { get set }

  // public api to set confirm flag
  func conformTermsAgreement(_ agree: Bool)
}
