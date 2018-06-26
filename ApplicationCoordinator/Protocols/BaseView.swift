// BaseView 是 coordinator 可操作的基本 view
// 因為需要 weak ref 所以為 class protocol
protocol BaseView: class, Presentable { }
