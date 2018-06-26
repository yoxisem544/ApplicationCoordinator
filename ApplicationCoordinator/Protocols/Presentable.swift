// Presentable 可用來讓 Coordinator 知道這是可以導向的 object
protocol Presentable {
  func toPresent() -> UIViewController?
}

// 原則上我們讓所有 UIViewController 都是 Presentable
extension UIViewController: Presentable {

  func toPresent() -> UIViewController? {
    // 準備要 present 時回傳本身
    return self
  }

}
