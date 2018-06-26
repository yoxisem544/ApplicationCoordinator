protocol LoginView: BaseView {
  // after login complete
  var onCompleteAuth: (() -> Void)? { get set }
  var onSignUpButtonTap: (() -> Void)? { get set }
}
