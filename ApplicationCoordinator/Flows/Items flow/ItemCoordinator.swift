final class ItemCoordinator: BaseCoordinator {
  
  private let factory: ItemModuleFactory
  private let coordinatorFactory: CoordinatorFactory
  private let router: Router
  
  init(router: Router, factory: ItemModuleFactory, coordinatorFactory: CoordinatorFactory) {
    self.router = router
    self.factory = factory
    self.coordinatorFactory = coordinatorFactory
  }
  
  override func start() {
    showItemList()
  }
  
  //MARK: - Run current flow's controllers
  
  private func showItemList() {

    // make item list view
    let itemsOutput = factory.makeItemsOutput()
    itemsOutput.onItemSelect = { [weak self] (item) in
      // when selecting item, coordinate to item detail view
      self?.showItemDetail(item)
    }
    itemsOutput.onCreateItem = { [weak self] in
      self?.runCreationFlow()
    }
    // this router is not app coordinator's router,
    // its item coordinator's router.
    router.setRootModule(itemsOutput)
  }
  
  private func showItemDetail(_ item: ItemList) {
    // make item detail view
    let itemDetailFlowOutput = factory.makeItemDetailOutput(item: item)
    // push to nav stack
    router.push(itemDetailFlowOutput)
  }
  
  //MARK: - Run coordinators (switch to another flow)
  
  private func runCreationFlow() {
    // make item create coordinator
    // create flow is another flow, make new coordinator here
    // cause its a new flow, coordinator has its own router
    // router has a nav controller, create view is contained in nav controller
    let (coordinator, module) = coordinatorFactory.makeItemCreationCoordinatorBox()
    coordinator.finishFlow = { [weak self, weak coordinator] item in
      
      self?.router.dismissModule()
      self?.removeDependency(coordinator)
      if let item = item { // if item is created, show detail
        self?.showItemDetail(item)
      }
    }
    addDependency(coordinator)
    coordinator.start()
    router.present(module) // maybe present after coordinator starts.
  }
}
