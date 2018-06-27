class OnboardingCoordinator: BaseCoordinator, OnboardingCoordinatorOutput {

  // onboarding finish flow
  var finishFlow: (() -> Void)?
  
  private let factory: OnboardingModuleFactory
  private let router: Router

  // init with factory and router
  //
  // router is needed here because of setting to root container
  init(with factory: OnboardingModuleFactory, router: Router) {
    self.factory = factory
    self.router = router
  }

  // override start, start with option is not required here
  override func start() {
    showOnboarding()
  }
  
  func showOnboarding() {
    let onboardingModule = factory.makeOnboardingModule()
    onboardingModule.onFinish = { [weak self] in
      self?.finishFlow?()
    }
    router.setRootModule(onboardingModule.toPresent())
  }
}
