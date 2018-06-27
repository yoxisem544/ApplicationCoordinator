class TabbarCoordinator: BaseCoordinator {
  
  private let tabbarView: TabbarView
  private let coordinatorFactory: CoordinatorFactory
  
  init(tabbarView: TabbarView, coordinatorFactory: CoordinatorFactory) {
    self.tabbarView = tabbarView
    self.coordinatorFactory = coordinatorFactory
  }
  
  override func start() {
    // initial state, run item flow
    tabbarView.onViewDidLoad = runItemFlow()
    tabbarView.onItemFlowSelect = runItemFlow()
    tabbarView.onSettingsFlowSelect = runSettingsFlow()
  }
  
  private func runItemFlow() -> ((UINavigationController) -> ()) {
    // FIXME: why no need to weak capture self
    return { navController in // will pass in a nav controller
      // check if nav controller have sub vcs, if not run coordinator
      if navController.viewControllers.isEmpty == true {
        // make a coordinator with nav controller,
        // no need for router, cause item coordinator has its own router.
        let itemCoordinator = self.coordinatorFactory.makeItemCoordinator(navController: navController)
        itemCoordinator.start()
        // cause item flow wont disappear, no need to remove dependency
        // but if application coordinator has chance to remove all displaying view hierarchy
        // might need to have a clear dependency method in app coordinator
        self.addDependency(itemCoordinator)
      }
    }
  }
  
  private func runSettingsFlow() -> ((UINavigationController) -> ()) {
    return { navController in
      if navController.viewControllers.isEmpty == true {
        let settingsCoordinator = self.coordinatorFactory.makeSettingsCoordinator(navController: navController)
        settingsCoordinator.start()
        self.addDependency(settingsCoordinator)
      }
    }
  }
}
