+++
date = "2015-04-28T23:03:56+08:00"
draft = true
title = "Swift 官博文章翻译 - 内存安全：确保值在使用前先初始化"

tags      = ["Cocoa", "AppDev", "Translation"]
languages = ["Swift", "ObjC", "Chinese", "English"]
platforms = ["MacOS", "iOS"]
+++

原文链接：[Memory Safety: Ensuring Values are Initialized Before Use](https://developer.apple.com/swift/blog/?id=28)

译者：Mudox

我们设计 Swift 这门语言时的一个重要的发力方向就是改进编程模型的内存安全性。内存安全有很多方面，本文将由浅入深，先从一个简单的问题开始：如果确保值在使用前被初始化。
<!--more-->

# Swift 的方式

如果每当一个变量第一次被访问时，该变量都有一个有效的初始值，那么该变量就被认为是“安全”的。不同的语言采用了不同的方式来提供这种安全性。比如 C 语言，它将责任完全交给程序员——这种方法强大，但是也很有难度。C++ 和 Objective-C 通过施加一些强制性的模式来改善此类情况，还有一些语言则（比较极端的）要求变量在定义时就必须初始化。

Swift 采用的主要技术是通过其先进的编译器来对代码的数据流进行分析。由编译器在编译时确保变量在使用前正确初始化，这是是一种名为 [明确初始化——Definitive Initialization](http://en.wikipedia.org/wiki/Definite_assignment_analysis) 的策略。还有很多语言比如 Java，C# 都采用了类似的策略，而 Swift 则是的该策略的一个扩展版本应用于更大范围的变量上面。

# 本地变量的明确初始化

在 Swift 中有很多场景都用到了该策略，其中最简单的场景就是用于本地变量。相较于“隐式的默认值初始化 implicit default initialization”，明确初始化初始化提供了更大的灵活性，因为它运行你写出如下的代码：

```swift
var myInstance : MyClass  // Uninitialized non-nullable class reference

if x > 42 {
  myInstance = MyClass(intValue: 13)
} else {
  myInstance = MyClass(floatValue: 92.3)
}

// Okay because myInstance is initialized on all paths
myInstance.printIt()
```

这里编译器能分析出 `if` 语言的两个分支里都对变量 `myInstance` 做了初始化，因此它确信后面的 `printIt()` 方法不会被调用于未初始化的内存上面。

明确初始化策非常强大，但是它只有在代码可靠并可预测的情况下才能发挥作用。当你的代码的控制流逻辑比较复杂时，它就可能出意外。比如如下代码：

```swift
var myInstance : MyClass

if x > 10 {
  myInstance = MyClass(intValue: 13)
}
// ...
if x > 42 {
  myInstance.printIt()
}
```
上述代码运行时，编译器会发出警告：“变量 `myInstance` 在使用前未初始化”。这是因为编译器并不能分析出上下两个 if 语句的条件之间的内在逻辑关系。尽管我们能让编译器照顾到此类个别特殊情况，但是它还是不可能覆盖所有的特殊情况（这其实就是所谓的“[停机问题 halting problem](http://en.wikipedia.org/wiki/Halting_problem)”），因此我们决定保持编译规则简单可预测。

Swift 使初始化一个变量变得极其简单。事实上用 Swift 在声明时给出初始化值 `var x = 0` 比声明一个未初始化的变量 `var x: Int` 所得到的代码更简短。Swift 提倡在任何可能的时候给声明的变量一个明确的初始化值。还有更加强大的方法就是通过调用 `init()` 方法来初始化一个变量。想要了解更加详细的信息，请参阅 Swfit Programming Language 的“[初始化 Initialization](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Initialization.html)” 一章。

# 其他的方式

除了明确初始化之外，Swift 在特定情况下也会采用一些其他的策略。您很可能已经在其他语言中碰到过这些策略，因此我们将在本文中简短的介绍下他们。他们都用各自不足之处，所以 Swift 并没有将他们当做主要策略来使用。

__将安全性交给程序员__：鉴于 C 的普及程度，我们有必要了解下简单的将安全性责任交给程序员这种做法的利与弊。在 C 中使用未经初始化的值会导致[不确定的行为 undefined behavior](http://blog.llvm.org/2011/05/what-every-c-programmer-should-know.html)，经常表现为程序的运行时异常。C 语言依赖程序永远都不要犯错误。我们设计 Swift 语言的初衷之一就是让它从本质上就是安全的，所以这一策略果断被我们排除于绝大部分情况之外。但是，Swift 还是提供了诸如 `UnsafePointer` 这样的 API，以允许你再绝对必要的情况下启用这种策略。

__隐式的默认值初始化__：可以让编译器隐式的初始化一个值，以确保其安全性。比如，在 Objective-C 中，给实例的成员变量设置一个初始的“零值”，或者像 C++ 那样给类提供默认的初始化器。我们曾深入探索过这一方法，但做种决定不广泛使用它。因为：

+ 它对与那些没有合理初始化值的类型不起作用，比如 protocol 对象并没有 `init()` 方法可以调用，已经在 Swift 非常普遍的不可为空的类引用。

+ 就算是对于基本类型，比如对于一个 integer 变量，0 常常在上下文中是一个不合理的值。这也是为什么在 Swift 中给变量赋初始化值如此容易的原因之一。此外，这让代码对于后续的维护者更加的清晰明了。

注意：对于 `Optional` 和 `ImplicitlyUnwrappedOptional` 这类可以为空的值，把他们默认初始化为空 `nil` 是理所当然的。因此在 Swift 中所有飞空值都会被自动初始化为空值。

__强制在定义时初始化__：强制要求程序在定义变量是给与其初始值，意味着 `var x: Int` 将是非法的，因为它没有提供初始值给编译器。尽管该策略通用于函数式编程语言中, 但是我们认为这一要求国语严格而没有必要，也妨碍了程序员对自然模式的表达。
