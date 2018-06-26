// Auth coordinator
//
// Its a coordinator, will have auth output, means auth flow finished.
final class AuthCoordinator: BaseCoordinator, AuthCoordinatorOutput {
  
  var finishFlow: (() -> Void)?
  
  private let factory: AuthModuleFactory
  private let router: Router
  private weak var signUpView: SignUpView?

  // coordinator needs rotuer to coordinate.
  // factory to build auth module
  // auth module have 3 different modules
  // 1. login
  // 2. sign up
  // 3. terms
  init(router: Router, factory: AuthModuleFactory) {
    self.factory = factory
    self.router = router
  }
  
  override func start() {
    showLogin()
  }
  
  // MARK: - Run current flow's controllers
  
  private func showLogin() {
    // when run show login flow,
    // first, factory will make a login output, a.k.a LoginView
    let loginOutput = factory.makeLoginOutput()
    loginOutput.onCompleteAuth = { [weak self] in
      // when login complete, call finish flow closure.
      self?.finishFlow?()
    }
    loginOutput.onSignUpButtonTap = { [weak self] in
      // if login view need to coordinate to sign up view
      // go show sign up flow
      self?.showSignUp()
    }
    // tell router to set current login view to root container
    // this will break current displaying view.
    router.setRootModule(loginOutput)
  }
  
  private func showSignUp() {
    // as usual, build a sign up handler a.k.a SignUpView
    signUpView = factory.makeSignUpHandler()
    signUpView?.onSignUpComplete = { [weak self] in
      // after sign up, maybe login first then execute finish flow closure.
      self?.finishFlow?()
    }
    signUpView?.onTermsButtonTap = { [weak self] in
      self?.showTerms()
    }
    router.push(signUpView)
  }
  
  private func showTerms() {
    // build terms output, a.k.a TermsView
    let termsOutput = factory.makeTermsOutput()
    // pull confirmed flag out of SignUpView
    termsOutput.confirmed = self.signUpView?.confirmed ?? false
    
    termsOutput.onConfirmChanged = { [weak self] confirmed in
      // change confirmed to terms
      self?.signUpView?.conformTermsAgreement(confirmed)
    }
    router.push(termsOutput, animated: true)
  }
}
