final class ModuleFactoryImp { }

extension ModuleFactoryImp : AuthModuleFactory {

  func makeLoginOutput() -> LoginView {
    return LoginController.controllerFromStoryboard(.auth)
  }

  func makeSignUpHandler() -> SignUpView {
    return SignUpController.controllerFromStoryboard(.auth)
  }

  func makeTermsOutput() -> TermsView {
    return TermsController.controllerFromStoryboard(.auth)
  }

}

extension ModuleFactoryImp : OnboardingModuleFactory {

  func makeOnboardingModule() -> OnboardingView {
    return OnboardingController.controllerFromStoryboard(.onboarding)
  }

}

extension ModuleFactoryImp : ItemModuleFactory {

  func makeItemsOutput() -> ItemsListView {
    return ItemsListController.controllerFromStoryboard(.items)
  }

  func makeItemDetailOutput(item: ItemList) -> ItemDetailView {

    let controller = ItemDetailController.controllerFromStoryboard(.items)
    controller.itemList = item
    return controller
  }

}

extension ModuleFactoryImp : ItemCreateModuleFactory {

  func makeItemAddOutput() -> ItemCreateView {
    return ItemCreateController.controllerFromStoryboard(.create)
  }

}

extension ModuleFactoryImp : SettingsModuleFactory {

  func makeSettingsOutput() -> SettingsView {
    return SettingsController.controllerFromStoryboard(.settings)
  }

}
