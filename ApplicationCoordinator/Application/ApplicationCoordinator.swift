// Flags for coordinator to determine which scene to coordinate.
fileprivate var onboardingWasShown = false
fileprivate var isAutorized = false

fileprivate enum LaunchInstructor {
  // we will have 3 entry points
  case main, auth, onboarding

  // configure launch instructor
  static func configure(
    tutorialWasShown: Bool = onboardingWasShown,
    isAutorized: Bool = isAutorized) -> LaunchInstructor {
    
    switch (tutorialWasShown, isAutorized) {
      case (true, false), (false, false): return .auth
      case (false, true): return .onboarding
      case (true, true): return .main
    }
  }
}

final class ApplicationCoordinator: BaseCoordinator {
  
  private let coordinatorFactory: CoordinatorFactory
  private let router: Router

  // next instructor getter
  private var instructor: LaunchInstructor {
    return LaunchInstructor.configure()
  }

  // will need a router to coordinate vcs,
  // coordinator factory to create next coordinators
  init(router: Router, coordinatorFactory: CoordinatorFactory) {
    self.router = router
    self.coordinatorFactory = coordinatorFactory
  }

  // override start with deeplink option
  override func start(with option: DeepLinkOption?) {
    // start with deepLink
    if let option = option {
      switch option {
      case .onboarding: runOnboardingFlow()
      case .signUp: runAuthFlow()
      default:
        childCoordinators.forEach { coordinator in
          // other options to start, pass it to other coordinators.
          coordinator.start(with: option)
        }
      }
    // default start
    } else {
      switch instructor {
      case .onboarding: runOnboardingFlow()
      case .auth: runAuthFlow()
      case .main: runMainFlow()
      }
    }
  }

  // first run, and not yet logged in
  private func runAuthFlow() {
    // build coordinator for auth flow
    // router is needed here for auth coordinator to coordinate its auth flow
    let coordinator = coordinatorFactory.makeAuthCoordinatorBox(router: router)
    coordinator.finishFlow = { [weak self, weak coordinator] in
      // when auth flow finished, change flag
      isAutorized = true
      self?.start() // start application coordinator again for next scene.
      self?.removeDependency(coordinator) // remove auth coordinator
    }
    addDependency(coordinator) // add coordinator
    coordinator.start() // start auth coordinator
  }

  // after auth flow, run onboarding flow
  private func runOnboardingFlow() {
    let coordinator = coordinatorFactory.makeOnboardingCoordinator(router: router)
    // FIXME: why weak coordinator here?
    // if coordinator is not capture weak here
    // finish flow in coordinator will keep 
    coordinator.finishFlow = { [weak self, weak coordinator] in
      onboardingWasShown = true
      self?.start()
      self?.removeDependency(coordinator)
    }
    addDependency(coordinator)
    coordinator.start()
  }
  
  private func runMainFlow() {
    let (coordinator, module) = coordinatorFactory.makeTabbarCoordinator()
    addDependency(coordinator)
    router.setRootModule(module, hideBar: true)
    coordinator.start()
  }
}
