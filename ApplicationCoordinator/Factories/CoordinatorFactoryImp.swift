final class CoordinatorFactoryImp: CoordinatorFactory {
  
  func makeTabbarCoordinator() -> (configurator: Coordinator, toPresent: Presentable?) {
    // make a tab bar from sb
    let controller = TabbarController.controllerFromStoryboard(.main)
    // build coordinator
    let coordinator = TabbarCoordinator(tabbarView: controller, coordinatorFactory: CoordinatorFactoryImp())
    return (coordinator, controller)
  }

  // will need router for auth coordinator to coordinate its auth flow
  // login -> signup -> terms
  func makeAuthCoordinatorBox(router: Router) -> Coordinator & AuthCoordinatorOutput {
    let coordinator = AuthCoordinator(router: router, factory: ModuleFactoryImp())
    return coordinator
  }
  
  func makeItemCoordinator() -> Coordinator {
    return makeItemCoordinator(navController: nil)
  }
  
  func makeOnboardingCoordinator(router: Router) -> Coordinator & OnboardingCoordinatorOutput {
    return OnboardingCoordinator(with: ModuleFactoryImp(), router: router)
  }
  
  func makeItemCoordinator(navController: UINavigationController?) -> Coordinator {
    let coordinator = ItemCoordinator(
      router: router(navController), // use nav controller to create a new router
      factory: ModuleFactoryImp(),
      coordinatorFactory: CoordinatorFactoryImp()
    )
    return coordinator
  }
  
  func makeSettingsCoordinator() -> Coordinator {
    return makeSettingsCoordinator(navController: nil)
  }
  
  func makeSettingsCoordinator(navController: UINavigationController? = nil) -> Coordinator {
    let coordinator = SettingsCoordinator(router: router(navController), factory: ModuleFactoryImp())
    return coordinator
  }

  // make new coordinator and a presentable module
  func makeItemCreationCoordinatorBox() ->
    (configurator: Coordinator & ItemCreateCoordinatorOutput,
    toPresent: Presentable?) {
      // pull a new navigation controller from sb.
      return makeItemCreationCoordinatorBox(navController: navigationController(nil))
  }
  func makeItemCreationCoordinatorBox(navController: UINavigationController?) ->
    (configurator: Coordinator & ItemCreateCoordinatorOutput,
    toPresent: Presentable?) {
      // create a new router
      let router = self.router(navController)
      // create item create flow coordinator
      let coordinator = ItemCreateCoordinator(router: router, factory: ModuleFactoryImp())
      // router is also a presentable, root nav controller inside router
      return (coordinator, router)
  }
  
  private func router(_ navController: UINavigationController?) -> Router {
    return RouterImp(rootController: navigationController(navController))
  }
  
  private func navigationController(_ navController: UINavigationController?) -> UINavigationController {
    if let navController = navController { return navController }
    else { return UINavigationController.controllerFromStoryboard(.main) }
  }
}
