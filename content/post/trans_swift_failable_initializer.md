+++
date = "2015-05-05T01:03:56+08:00"
draft = true
title = "Swift 官博文章翻译 - 可能失败的初始化器"

tags      = ["Cocoa", "AppDev", "Translation", "Xcode"]
languages = ["Swift", "ObjC", "Chinese", "English"]
platforms = ["MacOS", "iOS"]
+++

原文链接：[Failable Initializers](https://developer.apple.com/swift/blog/?id=22)

译者：Mudox

Xcode 6.1 带来了 Swift 1.1，后者引入了一个新的特性：可能失败的初始化器。初始化是给类或者结构体的存储属性一个初始值，并建立起实例的不变性的过程。在某些情况下，初始化可能会失败。
<!--more-->

比如，初始化过程需要访问某个资源（例如从文件中加载图片）：


```swift
NSImage(contentsOfFile: "swift.png")
```

如果这个文件不存在或者处于某种原因不能访问，那么上面的 `NSImage` 的初始化就会失败。有了 Swift 1.1 我们可以用可能失败的初始化器（failable initializer）来报告失败的初始化操作。通过可能失败的初始化器构建对象，返回的结果被包裹在可为空类型里，如果成功就返回包含初始化了的对象的可为空值，如果失败就返回 `nil`。因此上面的初始化需要对返回的可为空值做拆箱操作：


```swift
if let image = NSImage(contentsOfFile: "swift.png") {
  // loaded the image successfully
} else {
  // could not load the image
}
```

我们可以在 Swift 的初始化器声明后加上 `!` 或者 `?` 后缀来表示该初始化过程会返回可为空值，且具体是那种可为空类型。比我们可以对 `Int` 类型增加一个可能失败的初始化器以尝试将从一个字符串中初始化出一个整形值来：


```swift
extension Int {
  init?(fromString: String) { 
    if let i = fromString.toInt() {
      // Initialize
      self = i
    } else { 
      // return nil, discarding self is implied
      return nil
    }
  }
}
```

在可能失败的初始化器中返回 `nil` 指示这个初始化过程失败了，因为没有其他的值可以返回。在上面的字符串初始化整型值的例子中，如果字符串不成功的被解析为一个整形数字，那么就只能返回 nil 了。如果成功，就将 `self` 赋值为解析出来的整型值。

可能失败的初始化器大大降低了使用工厂方法（factory methods）的必要性，在此之前我们只能用工厂方法来报告失败的对象初始化。比如那些关联了原始类型的枚举类型，他们之前都是通过一个 `fromRaw` 工厂类方法来返回可为空的枚举值，以报告可能失败的初始化。现在 Swift 编译器会对那些尝试从一个原始类型值映射到一个枚举值的情况自动合成一个可能失败的初始化器。

```swift
enum Color : Int {
  case Red = 0, Green = 1, Blue = 2

  // implicitly synthesized
  var rawValue: Int { /* returns raw value for current case */ }

  // implicitly synthesized
  init?(rawValue: Int) {
    switch rawValue { 
      case 0: self = .Red
      case 1: self = .Green
      case 2: self = .Blue
      default: return nil
    }
  }
}
```

通过使用可能失败的初始化器，Swift 使其构造语法更加的统一，同时也消除了 Objective-C 中工厂方法和构造函数相互重复带来的困扰，从而大大的简化了新语言。有了可能失败的初始化器，Swift 现在把更多的带 `NSError *` 参数的 Cocoa 工厂方法视为初始化器处理，从而提供给用户更加统一，简洁的对象构造体验。

您可以在这里了解到更详细的关于可能失败的初始化器的内容：[Swift 编程语言](https://developer.apple.com/library/mac/documentation/Swift/Conceptual/Swift_Programming_Language/Initialization.html#//apple_ref/doc/uid/TP40014097-CH18-XID_339)
