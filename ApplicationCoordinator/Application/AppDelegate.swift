@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  var rootController: UINavigationController {
    // if you use storyboard, window exists
    // when generate with code, remember to init new window
    return self.window!.rootViewController as! UINavigationController
  }

  // Whole app start here, by making a coordinator.
  private lazy var applicationCoordinator: Coordinator = self.makeCoordinator()
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    // if app launch with remote notification
    let notification = launchOptions?[.remoteNotification] as? [String: AnyObject]
    // build a deeplink option
    let deepLink = DeepLinkOption.build(with: notification)
    // start application coordinator starts with option
    applicationCoordinator.start(with: deepLink)

    return true
  }

  private func makeCoordinator() -> Coordinator {
    // make app coordinator.
    return ApplicationCoordinator(
      // Init a Router, injectable for testing here
      // router need a nav controller as container
      // FIXME: maybe a root window instead of nav controller
      router: RouterImp(rootController: self.rootController),
      // Init a coordinator factory, injectable here
      coordinatorFactory: CoordinatorFactoryImp()
    )
  }
  
  // MARK: - Handle push notifications and deep links
  func application(_ application: UIApplication,
                   didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    let dict = userInfo as? [String: AnyObject]
    let deepLink = DeepLinkOption.build(with: dict)
    applicationCoordinator.start(with: deepLink)
  }
  
  func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                   restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
    let deepLink = DeepLinkOption.build(with: userActivity)
    applicationCoordinator.start(with: deepLink)
    return true
  }
}
