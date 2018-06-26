// 基本路由
//
// 一般 present/dismiss, push/pop 原本由 vc 做
// 現在抽出來由路由來做
// 好處是有 custom animator 也不衝突
// vc vc 間沒有耦合性
protocol Router: Presentable {

  // present a module
  // can determine if animated or not
  func present(_ module: Presentable?)
  func present(_ module: Presentable?, animated: Bool)

  // dismiss a modal presented view controller
  func dismissModule()
  func dismissModule(animated: Bool, completion: (() -> Void)?)

  // can determine completion handler
  func push(_ module: Presentable?)
  func push(_ module: Presentable?, animated: Bool)
  func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?)

  // navigation pop
  func popModule()
  func popModule(animated: Bool)

  // make a module root, can determine if navigation bar is hidden.
  func setRootModule(_ module: Presentable?)
  func setRootModule(_ module: Presentable?, hideBar: Bool)

  // return to root
  func popToRootModule(animated: Bool)
}
