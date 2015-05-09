+++
date = "2015-05-06T14:03:56+08:00"
draft = true
title = "Swift 官博文章翻译 - Swift REPL 的重定义特性"

tags      = ["Cocoa", "AppDev", "Translation", "Xcode"]
languages = ["Swift", "ObjC", "Chinese", "English"]
platforms = ["MacOS", "iOS"]
+++

原文链接：[Redefining Everything with Swift REPL](https://developer.apple.com/swift/blog/?id=20)

译者：Mudox

我们的之前的[第一篇关于 Swift REPL 的文章](/post/translation_swift_introduction_to_the_swift_repl/)只是简单的介绍了如何利用 REPL 来帮助您学习 Swift 语言的。本文将详细介绍 REPL 是如果绕过一些常规的语言编写规则来协助您开发 Swift 应用的。
<!--more-->

# 重定义标识符

Swift 编译器能自动检测出大量的代码错误，其中就包括重复定义标识符。

```bash
swiftc -
var x = "The Answer"
var x = 42
^D
error: invalid redeclaration of 'x'
```

在一般的代码编写场景中，这是合情合理的。但是在 REPL 交互式环境中，应该让用户更加容易的修改之前的代码。我们在设计 Swift REPL 时考虑到了这一点：

```swfit
  1> var x = "The Answer"
x: String = "The Answer"
  2> var x = 42
x: Int = 42
  3> x + 10
$R0: Int = 52
```

同一个标识符较近的定义会覆盖所有之前的定义。如上所示，您甚至可以在在下一次重复定义时改变变量的类型。重复定义方便您反复的修改优化您的代码。比如您要设计一个递归的函数：

```swfit
  4> func fib(index: Int) -> Int {
  5.   if index <= 1 {
  6.     return 1
  7.   }
  8.   return fib(index - 1) + fib(index - 2)
  9. }
 10> fib(40)
$R1: Int = 165580141
```

这是只是这个函数的其中一种实现。在 REPL 中您可以尽情的试验用其他的算法或者 API 来实现您的函数：

```swift
 11> func fib(index: Int) -> Int {
 12.   var lastValue = 1
 13.   var currentValue = 1
 14.   for var iteration = 2; iteration <= index; ++iteration {
 15.     let newValue = lastValue + currentValue
 16.     lastValue = currentValue
 17.     currentValue = newValue
 18.   }
 19.   return currentValue
 20. }
 21> fib(40)
$R2: Int = 165580141
```

直接把上面的重复的函数定义敲入 REPL 中，`fib` 函数的定义就会被 REPL 更新。这是只是一个很简单的例子，但是它展示了 REPL 是如果方便您反复试验并改进代码的。

# 重定义还是重载？

我们可以在 Swift REPL 中轻松重定义常量，变量，类型还有函数，一切都很直观，方便。但是问题来了，REPL 怎么区分并让函数重定义和函数重载共存能呢？Swift REPL 只会覆盖函数名和函数签名完全都相同的函数定义。如果只是函数名相同而签名不同，那么只会引入一个函数重载。请记住，在 Swift 中就算两个函数的签名只有返回类型不同，也算是函数重载。比如：

```swift
 22> func foo() {
 23.    println("Foo!")
 24. }
 25> func foo() -> String {
 26.    return "Foo!"
 27. }
 28> foo()
error: ambiguous use of 'foo'
```

上面的两个函数只有返回类型不同，所以您在调用他们时必须提供足够的上下文让编译器能够推导出被调用的函数具体的返回类型（从而判断出您要调用的到底是哪个函数）：

```swift
 28> var foo: String = foo()
foo: String = "Foo!"
 29> foo() as Void
Foo!
```

# 捕捉定义

尽管 REPL 允许重复定义，但是它只对后续出现的标识符有效。而之前已经被 REPL 编译过的那些代码行中的标识符引用的都还是之前的定义。这就好像新的定义只是替后面的代码遮住了旧的定义，而不是彻底的擦除了他们。下面的例子展示这个机制具体是如果运作的：

```swfit
 30> var message = "Hello, World!"
message: String = "Hello, World!"
 31> func printMessage() {
 32.    println(message)
 33. }
 34> printMessage()
Hello, World!
 35> message = "Goodbye"
 36> printMessage()
Goodbye
 37> var message = "New Message"
 38> printMessage()
Goodbye
 39> println(message)
New Message
```

让我们一行一行的看看到底发生了什么，第 30 行我们定义了一个名为 `message` 的变量，里面保存的是程序员御用问候语。第 31 ~ 33 定义了一个函数 `printMessage()` ，它打印出第 30 行定义的变量 `message` 保存的问候语。我们在第 34 行调用了 `printMessage()` ，问候语被打印出来。到目前为止，一切都很正常。

接着我们在第 35 行对之前在第 30 行定义的 `message`  变量赋予新值。在第 36 行我们再次调用 `printMessage()` ，和我们预期的一样，打印出来的是新赋予的字符串。然后我们在第 37 行重新定义了变量 `message`，这样就遮住了之前的定义，让后面的代码只能看到 `message` 的新的定义。但是我们在 38 调用的是 `printMessage()` 函数, 它恰恰是在重定义 `message` 之前定义的，因此它保留的是 `message` 之前的定义，打印还是之前的字符串。 而在第 39 行，我们敲入的是新代码，它引用的自然就是重定义之后的 `message`。

无论是函数，变量还是类型，他们在 REPL 中的重定义机制都是如此。尽管 REPL 能让您轻松的重定义标识符，但是重定义之前的被编译了的引用不会再改变。如果上面的 `message` 被重定义为一个类型而非变量会发生什么情况呢？`printMessage` 将不会再编译（这和我的实验不符，message 函数依然能被调用，打印的是之前的值）。与其每每碰到边界情况时没完没了的询问用户该怎么做，Swift REPL 努力坚持一个自我一致的世界观。
