+++
date = "2015-05-09T09:42:03+08:00"
draft = true
title = "Swift 官博文章翻译 - 在 Swift 中构建 assert(), 第一部分：__FILE__ 和 __LINE__"

tags      = ["Cocoa", "AppDev", "Translation", "Xcode"]
languages = ["Swift", "ObjC", "Chinese", "English"]
platforms = ["MacOS", "iOS"]
+++

原文链接：[Building `assert()` in Swift, Part 2: \_\_FILE\_\_ and \_\_LINE\_\_ ](https://developer.apple.com/swift/blog/?id=15)

译者：Mudox

大家都知道 C 语言里有两个宏 `__LINE__`，`__FILE__` 在某些场合下很有用。在编译器开始编译之前，预编译器都会将他们展开为当前的文件名和行号。尽管 Swift 没有预编译器，但是它也提供了这两个名字，并具有相同的作用，只是其运行机制截然不同。
<!--more-->

# 内建的标识符

正如[《Swift 语言编程指南》][swift_guide]说所，Swift 有一些内建的标识符，其中就包括 `__FLIE__`，`__LINE__`，`__COLUMN__` 和 `__FUNCTION__`。您可以在代码中的任何地方使用他们，Swift 编译器会将他们转变成表示当前代码位置的字符串或者和整形常量。当您想要手动记录事件时，比如在退出前打印出当前代码的位置，他们会非常有用。

[swift_guide]: http://developer.apple.com/library/prerelease/ios/documentation/swift/conceptual/swift_programming_language/LexicalStructure.html

```swift
func assert(predicate : @autoclosure () -> Bool) {
  #if DEBUG
    if !predicate() {
      println("assertion failed at \(__FILE__):\(__LINE__)")
      abort()
    }
  #endif
}
```

上面的代码只会打印出 `assert()` 函数体内部的位置，而不是我们想要的调用它的代码的位置。

# 获取调用者的位置

Swift 从 D 语言那里借鉴来一个非常聪明的做法：讲这些特殊的位置标识符作为参数的默认值。于是我们将 `asssert()` 函数定义为：

```swift
func assert(
  condition: @autoclosure () -> Bool,
  _ message: String = "",
       file: String = __FILE__,
       line: Int = __LINE__)
{
    #if DEBUG
      if !condition() {
        println("assertion failed at \(file):\(line): \(message)")
        abort()
      }
    #endif
}
```

函数 `assert()` 的第二个参数是一个可选的字符串，第三和第四个参数默认为调用代码行的位置。这样 `assert()` 将默认得到调用它的代码行的位置。当然您也可以在 `assert()` 基础上再包裹一层抽象，并将您认为合适的位置信息传主动递进 `assert()` 里面。比如如下的简单示例：

```swift
func logAndAssert(
  condition: @autoclosure () -> Bool,
  _ message: StaticString = "",
       file: StaticString = __FILE__,
       line: UWord = __LINE__)
{

  logMessage(message)
  assert(condition, message, file: file, line: line)
}
```

上面的代码中，函数 `logAndAssert()` 的调用位置被正确传递给 `assert()`。值得一提的是，我们给第二个参数使用了 `StaticString` 类型，他是一个和 `String` 类似的字符串类型，用来存储像 `__FILE__` 这样展开得到的字符串，使用它没有内存管理方面的开销。

除了被用于 `assert()` 函数的实现外，这些功能还被用于 Swift 版的 XCTest 框架的实现中。当然，他们也可以被用于您的代码库的实现里。
