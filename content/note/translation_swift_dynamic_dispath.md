+++
date = "2015-04-29T10:03:56+08:00"
draft = true
title = "Swift 官博文章翻译 - 通过减少动态调度来拉升程序性能"

tags      = ["Cocoa", "AppDev", "Translation"]
languages = ["Swift", "ObjC"]
platforms = ["MacOS", "iOS"]
+++

原文链接：[Increasing Performance by Reducing Dynamic Dispatch ](https://developer.apple.com/swift/blog/?id=27)

译者：Mudox

和其他很多语言一样，Swift 运行程序员改写从父类集成来的方法和属性。这意味着程序得在运行时也只用在运行时才能判断所引用的具体的方法或属性，并间接的调用或访问他们。这一技术名为“动态分配 dynamic dispatch”，通过为每次间接调用或访问增加常亮时间的开销来换取语言表达能力的提升。对于性能苛刻的代码，这类开销是不可取的。本文将展示三种通过消除此类动态性来拉升程序性能的方法：`final`，`private` 以及整模块优化策略。
<!--more-->

请看如下代码:

```swift
class ParticleModel {
  var point = ( 0.0, 0.0 )
  var velocity = 100.0

  func updatePoint(newPoint: (Double, Double), newVelocity: Double) {
    point = newPoint
    velocity = newVelocity
  }

  func update(newP: (Double, Double), newV: Double) {
    updatePoint(newP, newVelocity: newV)
  }
}

var p = ParticleModel()
for i in stride(from: 0.0, through: 360, by: 1.0) {
  p.update((i * sin(i), i), newV:i*1000)
}
```

编译器将会生成如下动态分派代码：

1. 调用 `update` 于 `p`。
2. 调用  `updatePoint` 于 `p`。
3. 访问 `p` 的 `point` 元祖属性。
4. 访问 `p` 的 `velocity` 属性。

这也许并不是你想要的。动态调度在这里之所以必要，是因为 `ParticleModel` 的子类可能重写其属性。

在 Swift 中，动态调度通过从函数表中搜索正确的函数并间接调用他们来实现。这显然比直接调用来的慢。此外，间接调用还会阻碍很多编译器对代码的优化，这又进一步增加了程序运行的开销。在性能关键的代码中，Swift 提供了一些技术来关闭某些不必要的动态调度以拉升程序性能。

## 当你确定某个声明不会被覆盖时，使用 `final` 关键字

关键字 `final` 可以修饰类，方法或者属性的声明，它指示编译器这些声明不会被后续代码覆盖。这样编译器就能放心的在这些对象上关闭动态调度特性（不生成动态调度的代码）。比如下面的类属性 `point`，`velocity` 和函数 `updatePoint()` 将被直接访问和调用。而方法 `update()` 仍然需要通过动态调度来间接的被调用，它也因此能被子类们覆盖。

```swift
class ParticleModel {
  final var point = ( x: 0.0, y: 0.0 )
  final var velocity = 100.0

  final func updatePoint(newPoint: (Double, Double), newVelocity: Double) {
    point = newPoint
    velocity = newVelocity
  }

  func update(newP: (Double, Double), newV: Double) {
    updatePoint(newP, newVelocity: newV)
  }
}
```
It is possible to mark an entire class as final by attaching the attribute to the class itself. This forbids subclassing the class, implying that all functions and properties of the class are final as well.

您可以用 `final` 修饰整个类的声明，这样做将直接禁止对该类的子类化，因此对其所有属性和方法的访问将都是直接的。

```swift
final class ParticleModel {
  var point = ( x: 0.0, y: 0.0 )
  var velocity = 100.0
  // ...
}
```

## 为 `private` 声明自动推导 `final` 语义

被 `private` 修饰的声明其可见性会限制在声明它的文件里。如果在该文件里，没有发现对该声明的覆盖，编译器就不会为该声明生成动态调度代码，而是直接的访问他们。

假设在该文件中，没有对类 `ParticleModel` 的覆盖，那么编译器就会关闭对其所有 `private` 成员的动态调度，取而代之以更加快速的直接访问。
Assuming there is no class overriding ParticleModel in the current file, the compiler can replace all dynamically dispatched calls to private declarations with direct calls.

```swift
class ParticleModel {
  private var point = ( x: 0.0, y: 0.0 )
  private var velocity = 100.0

  private func updatePoint(newPoint: (Double, Double), newVelocity: Double) {
    point = newPoint
    velocity = newVelocity
  }

  func update(newP: (Double, Double), newV: Double) {
    updatePoint(newP, newVelocity: newV)
  }
}
```
上述代码中，`point`，`velocity` 和 `updatePoint()` 将被直接访问和调用。由于 `update()` 没有被 `private` 修饰，它仍然需要被动态调度。

和 `final` 一样，`private` 也可以被用来直接修饰整个类声明，这相当于在该类的所有成员声明面前加了 `private` 关键字。

```swift
private class ParticleModel {
  var point = ( x: 0.0, y: 0.0 )
  var velocity = 100.0
  // ...
}
```

# 通过模块级的优化来对 `internal` 声明推导出 `final` 语义

在 Swift 中，所有声明的可见性默认为 `internal`，也就是说他们只能在定义他们的模块内可见。编译器通常会单独的编译模块内的每个文件，因此它在变异某一个源文件时，无法判断在同意模块内的其他源文件里是否对该源文件内定义的 `internal` 声明的覆盖。但是如果我们启用了编译器的 `Whole Module Optimization` 模块级优选项，所以的文件将在一次编译过程中全部被编译。这样编译器就能在整个模块范围类分析是否某个 `internal` 声明被覆盖了，从而推导出 `final` 语义以关闭动态调度特性。

让我们回到最开始的代码，这回我们额外添加一些 `public` 关键到 `ParticleModel` 的声明中。

```swift
public class ParticleModel {
  var point = ( x: 0.0, y: 0.0 )
  var velocity = 100.0

  func updatePoint(newPoint: (Double, Double), newVelocity: Double) {
    point = newPoint
    velocity = newVelocity
  }

  public func update(newP: (Double, Double), newV: Double) {
    updatePoint(newP, newVelocity: newV)
  }
}

var p = ParticleModel()
for i in stride(from: 0.0, through: times, by: 1.0) {
  p.update((i * sin(i), i), newV:i*1000)
}
```

当开启了模块级优化选项的编译器处理以上代码时，它能够推导出 `point`, `velocity` 和 `updatePoint()` 方法可以关闭动态调度特性。与此相反，由于 `update()` 被 `public` 修饰，其可见性延伸到了模块之外，所以编译器无法断定它具有 `final` 语义。
