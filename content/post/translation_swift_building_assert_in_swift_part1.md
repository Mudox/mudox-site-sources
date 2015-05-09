+++
date = "2015-05-09T09:02:59+08:00"
draft = true
title = "Swift 官博文章翻译 - 在 Swift 中构建 assert()，第一部分：延迟计算"

tags      = ["Cocoa", "AppDev", "Translation", "Xcode"]
languages = ["Swift", "ObjC", "Chinese", "English"]
platforms = ["MacOS", "iOS"]
+++

原文链接：[Building assert() in Swift, Part 1: Lazy Evaluation ](https://developer.apple.com/swift/blog/?id=4)

译者：Mudox

我们在设计 Swift 语言时做出了一个关键的决断就是抛弃 C 语言的预编译器的概念，这样做不仅彻底消除了使用它可能带来的很多 bug，还让代码明了易懂。这对程序员来说是一个巨大的利好，但是它也意味着 Swift 必须用新的技术来实现一些旧的特性。大部分这样的特性的实现都很明了（模块导入，条件化编译），其中大家可能最感兴趣的就是 Swift 是如果支持类似 `assert`() 这样的宏定义的。
<!--more-->

当我们在 C 语言下编译可执行文件的 release 版本时，`assert()` 宏并不对运行时性能有任何影响，因为它并不处理任何参数。它在 C 语言下的可能是这样实现的：

```c
#ifdef NDEBUG
#define assert(e)  ((void)0)
#else
#define assert(e)  \
  ((void) ((e) ? ((void)0) : __assert (#e, __FILE__, __LINE__)))
#define __assert(e, file, line) \
  ((void)printf ("%s:%u: failed assertion `%s'\n", file, line, e), abort())
#endif
```

Swift 版的 `assert()` 提供和 C 版本同样的功能，没有用到预编译，而且我们以一种更加干净的方式实现了它。

# 实参的延迟计算

我们在实现 `assert()` 时，首先碰到的挑战就是，在 Swift 中没有明显的方法让一个函数接受一个表达式，而不立马求它的值。比方说，我们尝试用了：

```swift
func assert(x : Bool) {
  #if !NDEBUG

    /*noop*/
  #endif
}
```

即使断言被禁用了，应用程序也得承担对实参表达求值的运行时开销：

```swift
assert(someExpensiveComputation() != 42)
```

我们或许可以通过让断言改而接受一个闭包来补救它：

```swift
func assert(predicate : () -> Bool) {
  #if !NDEBUG
    if !predicate() {
      abort()
    }
  #endif
}
```

被裹进闭包的表达式只有在断言被启用的情况下才会被求值：

```swift
assert({ someExpensiveComputation() != 42 })
```

但是这样的话，我们又不得不使用这种奇怪的调用语法：

```swift
assert({ someExpensiveComputation() != 42 })
```

我们可以使用 Swift 提供的属性 `@autoclosure` 来补救这一点。自动闭包（auto-closure）属性可以修饰函数的参数，它只是编译器自动将被修饰的实参裹进一个闭包里，就好像如下的代码：

```swift
func assert(predicate : @autoclosure () -> Bool) {
  #if !NDEBUG
    if !predicate() {
      abort()
    }
  #endif
}
```

它允许您这样调用断言：

```swift
assert(someExpensiveComputation() != 42)
```

自动闭包是一个强大的特性，它能让您有条件的计算一个表达式，甚至计算多次，就像使用闭包那样。自动闭包也被用在 Swift 的其他很多地方。比如实现短路估值（short-circuiting）的逻辑运算符，如下：

```swift
func &&(lhs: BooleanType, rhs: @autoclosure () -> BooleanType) -> Bool {
  return lhs.boolValue ? rhs().boolValue : false
}
```

Swift 将表达式的右操作数声明为自动闭包以让它的估值得以延迟。

# 自动闭包

和 C 语言的断言宏一样，自动闭包特性很强大，因而我们必须谨慎使用它。因为调用方不会知道他传入的实参的求值时机被改变了，自动闭包被刻意限制不接受任何参数，您不应该拿他们当某种控制流来使用。只有当用它可以实现用户预期的语义效果时，我们才使用它，而不是用它来仅仅为了消除闭包的语法的花括号。

本文探讨 Swift 实现 `assert()` 所使用的技术的一个方面，我们将在后续文章讨论其他的方面。

