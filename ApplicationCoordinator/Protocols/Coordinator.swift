// Base Coordinator
// coordinator 基本功能
protocol Coordinator: class {
  // 啟動
  func start()
  // 帶有 deeplink option 然後啟動
  // DeepLink 可能為 push notification, url scheme, deep link...
  func start(with option: DeepLinkOption?)
}

