+++
date = "2015-05-02T13:03:56+08:00"
draft = true
title = "Swift 官博文章翻译 - as! 运算符"

tags      = ["Cocoa", "AppDev", "Translation"]
languages = ["Swift", "ObjC", "Chinese", "English"]
platforms = ["MacOS", "iOS"]
+++

原文链接：[The as! Operator](https://developer.apple.com/swift/blog/?id=23)

译者：Mudox

在 Swift 1.2 之前，`as` 运算符可以用来完成两种不同类型转换操作。取决要转换的表达式的类型，和要转化到的类型，`as` 运算符可以完成如下两种转化：

+ __总是能成功的类型转化__，编译器能在编译时判断出这类转换总是能成功。比如向上转换（upcasting —— 将一个对象引用转化为自己的一个父类或者祖先类类型) 或者在给字面值常亮添加类型注释（比如, `1 as Float`）。

+ __强制类型转化__，此类转换 Swift 编译器不能确保其绝对成功，如果不成功就引发运行时异常。比如乡下转换（downcasting —— 将一个对象引用转化为其某个子孙类类型）。

Swift 1.2 把这两中操作分割开来，变成了两个独立的运算符。总是能成功的转化还是使用 `as` 运算符，二强制转化则使用新的 `as!` 运算符（注意这里不是两个运算符叠加在一起，它就是__一个__运算符）。 `!` 暗示此类型转化可能会失败。这样，你一眼扫过代码就能知道那个类型转化会引发程序奔溃。
<!--more-->

如下示例展示了这个新的语言变更：

```swift
class Animal {}
class Dog: Animal {}

let a: Animal = Dog()
a as Dog                // now raises the error:  "'Animal is not convertible to 'Dog';
                        // ... did you mean to use 'as!' to force downcast?"

a as! Dog               // forced downcast is allowed

let d = Dog()
d as Animal             // upcast succeeds
```

注意区分作为表达式后缀运算符的 `!` 和 `?` 以及转换运算符 `as!`，`as?`：

译者注，用于类型注释时（type annotation）：

+  后缀运算符 `!` 表示要强制拆箱可为空类型 (forced unwrapping)

+  后缀运算符 `?` 可为空类型的级联访问（optional chaining）

在声明可为空类型时：

+ `!` 后缀声明一个隐式拆箱的可为空类型（implicitly unwrapped optional）

+ `?` 类型后缀声明一个普通的可为空类型（optional）

```swift
class Animal {}

class Cat: Animal {}

class Dog: Animal {
  var name = "Spot"
}

let dog: Dog? = nil
dog?.name               // evaluates to nil
dog!.name               // triggers a runtime error

let animal: Animal = Cat()
animal as? Dog  // evaluates to nil
animal as! Dog  // triggers a runtime error
```

您可以简单记忆为：在 Swift 中 `!` 暗示 __可能会失败__，`?` 暗示 __可能为空 nil__。
