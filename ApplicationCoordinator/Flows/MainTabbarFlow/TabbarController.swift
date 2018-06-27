final class TabbarController: UITabBarController, UITabBarControllerDelegate, TabbarView {
  
  var onItemFlowSelect: ((UINavigationController) -> ())?
  var onSettingsFlowSelect: ((UINavigationController) -> ())?
  var onViewDidLoad: ((UINavigationController) -> ())?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    delegate = self
    if let controller = customizableViewControllers?.first as? UINavigationController {
      onViewDidLoad?(controller)
    }
  }
  
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    guard let controller = viewControllers?[selectedIndex] as? UINavigationController else { return }

    // 2 tab bar items here
    // first is item flow
    if selectedIndex == 0 {
      onItemFlowSelect?(controller)
    }
    // second is setting flow
    else if selectedIndex == 1 {
      onSettingsFlowSelect?(controller)
    }
  }
}
