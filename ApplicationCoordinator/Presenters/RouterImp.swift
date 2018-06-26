// Router Implementation
final class RouterImp: NSObject, Router {

  // In this condition, use navigation as container.
  private weak var rootController: UINavigationController?

  // completion handlers for
  // FIXME: add doc
  private var completions: [UIViewController : () -> Void]

  // Init with a root nav controller.
  init(rootController: UINavigationController) {
    self.rootController = rootController
    completions = [:]
  }

  // toPresent of a router is root container.
  func toPresent() -> UIViewController? {
    return rootController
  }

  // convenience present, default animation true.
  func present(_ module: Presentable?) {
    present(module, animated: true)
  }

  // present a module
  func present(_ module: Presentable?, animated: Bool) {
    // check if there is module to present.
    guard let controller = module?.toPresent() else { return }
    // then tell root controller to present it.
    rootController?.present(controller, animated: animated, completion: nil)
  }

  // just dismiss module, with animatino, without completion
  func dismissModule() {
    dismissModule(animated: true, completion: nil)
  }

  // dismiss modal presentation
  func dismissModule(animated: Bool, completion: (() -> Void)?) {
    rootController?.dismiss(animated: animated, completion: completion)
  }
  
  func push(_ module: Presentable?)  {
    push(module, animated: true)
  }
  
  func push(_ module: Presentable?, animated: Bool)  {
    push(module, animated: animated, completion: nil)
  }

  // push a module to nav stack
  func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
    // check if there is module to present
    // then check if controller is not a nav controller
    // FIXME: why shouldn't we push a nav inside nav?
    guard
      let controller = module?.toPresent(),
      (controller is UINavigationController == false)
      else { assertionFailure("Deprecated push UINavigationController."); return }

    // if completion exists, keep ref to controller and completion hanlder.
    if let completion = completion {
      completions[controller] = completion
    }
    rootController?.pushViewController(controller, animated: animated)
  }
  
  func popModule()  {
    popModule(animated: true)
  }
  
  func popModule(animated: Bool)  {
    if let controller = rootController?.popViewController(animated: animated) {
      // after popping a controller from nav stack
      // check and run completion handler for this controller.
      runCompletion(for: controller)
    }
  }
  
  func setRootModule(_ module: Presentable?) {
    setRootModule(module, hideBar: false)
  }

  // setting root module to root nav container.
  // nothing special, just clear the nav stack.
  func setRootModule(_ module: Presentable?, hideBar: Bool) {
    guard let controller = module?.toPresent() else { return }
    rootController?.setViewControllers([controller], animated: false)
    rootController?.isNavigationBarHidden = hideBar
  }
  
  func popToRootModule(animated: Bool) {
    if let controllers = rootController?.popToRootViewController(animated: animated) {
      // when pop to root, run all completion handlers for all controllers popped.
//      controllers.forEach { controller in
//        runCompletion(for: controller)
//      }
      // can do it this way.
      controllers.forEach(runCompletion)
    }
  }
  
  private func runCompletion(for controller: UIViewController) {
    guard let completion = completions[controller] else { return }
    completion()
    completions.removeValue(forKey: controller)
  }
}
