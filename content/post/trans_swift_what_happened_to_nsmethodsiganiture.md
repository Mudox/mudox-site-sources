+++
date = "2015-05-06T14:03:56+08:00"
draft = true
title = "Swift 官博文章翻译 - NSMethodSiganiture 发生了什么？"

tags      = ["Cocoa", "AppDev", "Translation", "Xcode"]
languages = ["Swift", "ObjC", "Chinese", "English"]
platforms = ["MacOS", "iOS"]
+++

原文链接：[What Happened to NSMethodSiganiture?](https://developer.apple.com/swift/blog/?id=19)

译者：Mudox

将 Cocoa 框架引入 Swift 语言带给我们一个独一无二的机会，让我们能从一个全新的角度重新审视之前的 APIs 的合理性。我们发现，多数是由于 Swift 对安全性的要求，Cocoa 框架中的一些 API 不能很好的适应 Swift。那些与动态方法调用有关的的类无法导入到 Swift 中，比如 `NSInvocation`，`NSMethodSiganiture`。
<!--more-->

我们最近收到了一个开发人员的 bug 报告，他试图把他的的代码移植到 Swift，打算使用 `NSMethodSiganiture` 来检视方法实参的类型，结果发现 `NSMethodSiganiture` 并没有导入到 Swift 中。他要移植的代码需要接受不同签名的 HTTP 处理函数，比如：

```swift
func handleRequest(request: HTTPRequest, queryStringArguments: [String: String]) { }
func handleRequest(request: HTTPRequest, jsonBody: JSON) { }
```

在 Objective-C 中，可以用 `NSMethodSiganiture` 判断出第一个方法需要 `[String: String]` 作为实参，而第二个方法则需要 `JSON` 值。而 Swift 的功能十分强大，无需 `NSMethodSiganiture`，也不会违反编译器提供类型和内存安全性规则就能轻松处理好此类情况。下面的代码用 Swift 的方式来解决上面的问题：

```swift
struct HTTPRequest {
  // ...
}

protocol HTTPHandlerType {
  typealias Data

  /// :returns: true if the request was handled; false otherwise
  func handle(request: HTTPRequest, data: Data) -> Bool
}
```

我们首先声明一个协议定义处理 HTTP 请求需要满足的接口。这个协议非常简单，只有一个方法。

为什么不子类型化 `HTTPHandler` 呢，因为使用协议能提供更大灵活性，由用户来决定用什么来实现。如果我们定义的时一个 `HTTPHandler` 类，那么就会要求用户只能使用类类型，强迫他们使用引用类型。反之使用协议的换，用户可以自用的决定用什么来实现协议，用类，结构体甚至是枚举类型都可以。

```swift
class HTTPServer {
  func addHandler<T: HTTPHandlerType>(handler: T) {
    handlers.append { (request: HTTPRequest, args: Any) -> Bool in
      if let typedArgs = args as? T.Data {
        return handler.handle(request, data: typedArgs)
      }
      return false
    }
  }

  // ...
}
```

然后我们定义一个 `HTTPServer` 类，给它添加一个泛型方法，接受一个遵守 `HTTPHandlerType` 协议的类型参数。有了这个关联的类型参数，我们就可以通过对传入的请求数据执行条件化的向下转化来判断某个处理函数是否能处理此类数据。这就是定义协议的好处，`HTTPServer` 不需要知道处理器如何处理数据，甚至不需要知道它的具体类型。它只需确认这个对象有处理请求的能力（接口）就好了。

```swift
class HTTPServer {
  // ...

  private var handlers: [(HTTPRequest, Any) -> Bool] = []

  func dispatch(req: HTTPRequest, args: Any) -> Bool {
    for handler in handlers {
      if handler(req, args) {
        return true
      }
    }
    return false
  }
}
```

当我们的 `HTTPServer` 需要处理请求是，它只需便利我们的请求处理对象，看哪个能处理传入的请求和数据。

现在我们就可以轻松的创建处理各式各样类型数据的请求处理对象，并把他们注册到 `HTTPServer` 上。


```swift
class MyHandler : HTTPHandlerType {
  func handle(request: HTTPRequest, data: Int) -> Bool {
    return data > 5
  }
}

let server = HTTPServer()
server.addHandler(MyHandler())
server.dispatch(HTTPRequest(...), args: "x") // returns false
server.dispatch(HTTPRequest(...), args: 5)   // returns false
server.dispatch(HTTPRequest(...), args: 10)  // returns true
```

通过组合使用协议和泛型，我们可以用 Swift 优雅的定义处理各式各样数据类型的 HTTP 请求对象。同时也不会破坏编译器施加的安全性规则，并获得出色的运行时表现。

您可以下载本文完整的示例代码，我们把它放在了一个 [Swift Playground](https://developer.apple.com/swift/blog/downloads/Request.zip) 中。
