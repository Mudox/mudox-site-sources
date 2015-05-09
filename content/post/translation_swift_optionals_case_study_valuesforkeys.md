+++
date = "2015-05-08T08:58:04+08:00"
draft = true
title = "Swift 官博文章翻译 - 可为空类型案例分析：valueForKeys"

tags      = ["Cocoa", "AppDev", "Translation", "Xcode"]
languages = ["Swift", "ObjC", "Chinese", "English"]
platforms = ["MacOS", "iOS"]
+++

原文链接：[Optionals Case Study: valuesFoyKeys](https://developer.apple.com/swift/blog/?id=12)

译者：Mudox

本文我们将探索下可为空类型（optionals）是如果帮助 Swift 保持类型安全的。我将创建一个 Ojbective-C API 的 Swift 版本。尽管在 Swift 我们并不需要用到它，但是它确实一个有趣的例子。
<!--more-->

在 Objective-C 中，`NSDictionary` 类有一个方法 `objectsForKeys:notFoundMarker`，它接受一个 `NSArray` 参数，您把要查询的键值对的键放进去，它会就把对应的值存放进另一个 `NSArray` 中返回。文档上说，返回的数组中的值和您存入到数组中的键是一一对应的。但是如果其中一个键在字典里没有对应的值呢？所以我们还需要传入另一个参数 `notFoundMarker`。对于那些在字典中没有对应值的键，`objectsForKeys:notFoundMarker` 会在返回的数组中用 `notFoundMarker` 的值来填补空位。Foundation 框架甚至为我们预定义好了一个专门表示空值的类： `NSNull`。

在 Swift 中 `Dictionary` 类型并没有提供与 `objectsForKeys` 对应的方法。下面我们将要通过延展来给 `Dictionary` 类型添加这个方法。

```swift
extension Dictionary {
  func valuesForKeys(keys: [K], notFoundMarker: V) -> [V] {
    // To be implemented
  }
}
```

Swif 与 Objective-C 不同，它有很严格的类型检查。因此上面的方法返回的数组只能存放一种类型，所以不能用放入 `NSNull` 来表示空值。但是 Swift 提供了更好的解决方法：我们可以返回一组可为空值，所有的值被包裹进可为空值里。这样我们就能直接用 `nil` 来表示空值了。

```swift
extension Dictionary {
  func valuesForKeys(keys: [Key]) -> [Value?] {
    var result = [Value?]()
    result.reserveCapacity(keys.count)
    for key in keys {
      result.append(self[key])
    }
    return result
  }
}
```

你们可能已经想到为什么 Swift 的 `Dictionary` 不提供 `objectsForKeys` 方法了，因为我们可以用如下简短的代码，达到同样的效果：

```swift
extension Dictionary {
  func valuesForKeys(keys: [Key]) -> [Value?] {
    return keys.map { self[$0] }
  }
}
```

这就是为什么 Swift 类型总是比他们的 Objective-C 里的对应的类型提供的 API 要少很多的原因：通过 `map` 方法，我们可以轻松完成各种旧 API 的工作，而且有更多可能性。

现在我们来试用一下上面定义的 `objectsForKeys` 方法：

```swift
let dict = ["A": "Amir", "B": "Bertha", "C": "Ching"]

dict.valuesForKeys(["A", "C"])
// [Optional("Amir"), Optional("Ching")]

dict.valuesForKeys(["B", "D"])
// [Optional("Bertha"), nil]

dict.valuesForKeys([])
// []
```

# 可为空值嵌套

现在我们修改一下上面的代码，在每行后面加个 `.last`， 去结果集的最后一个元素：

```swift
dict.valuesForKeys(["A", "C"]).last
// Optional(Optional("Ching"))

dict.valuesForKeys(["B", "D"]).last
// Optional(nil)

dict.valuesForKeys([]).last
// nil
```

奇怪了，第一行代码返回了两个嵌套的可为空值。第二为 `Optional(nil)`。这是怎么回事呢？

还记得 `.last` 的定义么：

```swift
var last: T? { get }
```

`last` 是一个计算属性，其类型是可为空的元素类型。由于上面的 `objectsForKeys` 放回的数组的元素本身也是可为空类型，所以我们得到就是嵌套的可为空类型了。

那么 `Optional(nil)` 又是什么意思呢：

我们知道 Objective-C 中我们需要用 `NSNull` 来作为空值占位符。上面代码的 Objective-C 版本应该是：

```objc
[dict valuesForKeys:@[@"A", @"C"] notFoundMarker:[NSNull null]].lastObject
// @"Ching"

[dict valuesForKeys:@[@"B", @"D"] notFoundMarker:[NSNull null]].lastObject
// NSNull

[dict valuesForKeys:@[] notFoundMarker:[NSNull null]].lastObject
// nil
```

不管是在 Swift 中还是 Objective-C 中，返回 `nil` 都表示中间结果集为空，因为空集没有最后元素。当 Swift 的版本返回 `Optional(nil)` （或者 Objective-C 版本返回 `NSNull` ）时，这表示中间结果集里是有元素的，只是这个元素表示空值。Objective-C 必须预定义一个类型 `NSNull` 来表示空值，而 Swift 的类型系统直接就能表示它。

# 提供默认值

如果您依然想用其他的值来替代字典中缺失的值呢？很容易：

```swift
extension Dictionary {
  func valuesForKeys(keys: [Key], notFoundMarker: Value) -> [Value] {
    return self.valuesForKeys(keys).map { $0 ?? notFoundMarker }
  }
}
```

Swift 的类型系统提供了丰富语法支持来处理一可为空类型返回的结果，而不用像 Objective-C 那样要定义一个类型来作为占位符。
