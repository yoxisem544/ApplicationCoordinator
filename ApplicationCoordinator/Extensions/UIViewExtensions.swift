extension UIView {
  
  private class func viewInNibNamed<T: UIView>(_ nibNamed: String) -> T {
    return Bundle.main.loadNibNamed(nibNamed, owner: nil, options: nil)!.first as! T
  }

  /// Can be use as `UIView.nib()`
  class func nib() -> Self {
    return viewInNibNamed(nameOfClass) // cause return type is Self, imply that T is Self.
  }

  /// Set nib's frame while init
  class func nib(_ frame: CGRect) -> Self {
    let view = nib()
    view.frame = frame
    view.layoutIfNeeded()
    return view
  }
}
