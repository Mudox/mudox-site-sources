+++
date = "2015-05-04T01:03:56+08:00"
draft = true
title = "Swift 官博文章翻译 - Swift 1.2 和 Xcode 6.3 新特性介绍"

tags      = ["Cocoa", "AppDev", "Translation", "Xcode"]
languages = ["Swift", "ObjC", "Chinese", "English"]
platforms = ["MacOS", "iOS"]
+++

原文链接：[Swift 1.2 and Xcode 6.3 beta](https://developer.apple.com/swift/blog/?id=22)

译者：Mudox

Xcode 6.3 beta 给我们带来了 Swift 1.2 beta 版。不仅 Swift
编译器性能得到显著提升，还带了很多新的 Swift 语言特性。
如需了解全部的变更，请参阅本次的版本说明。本文将着重介绍其中的若干亮点。
<!--more-->

# 编译器改进

Swift 1.2 的编译器变得更加稳定，并全面提升了编译器性能。同时它能带来了诸多特性能是您再 Xcode 中使用 Swift 时有更好的体验。其中一些明显的改进包括：

+ __增量构建__

    默认情况下编译器不会再重复编译没有改变过的源文件，这将使绝大多数情况下的编译时间大大缩短。当然，如果您对代码结构做了大规模的改动后，依然可能导致编译器编译多个文件。

+ __生成更加快速的代码__

    Debug 和 Release 模式下生成的可执行文件的运行速度都大大提升了。

+ __更强大的编译诊断能力__

    增强的 Fix-its 功能，能帮助您扫除各种错误和警告，从而写出正确的 Swift 1.2 代码。

+ __稳定性提升__

    我们修复了大多数用户常见的 SourceKit 警告。您将不再被此类提示困扰。

# 新的语言特性

在 1.2 中我们进一步改善了 Swift 语言，使之更加安全，可预测。我们继续改进 Swift 和 Objective-C 之间的交互。其中一些显著的进步包括：

+ __新的 `as!` 运算符来表示可能失败的类型转换__

    那些在运行时不一定成功的类型转换必须明确的用 `as!` 来表示。从而使得代码的意图和后或对后续的阅读者和维护人员更加明了。

+ __可以在 Objective-C 头文件中添加可为空性注释__

    Clang 中引入了一个新的 Objective-C 语言扩展，能再您的 Objective-C API 中明确标注出指针和块引用的可为空性。这样您就能写出与 Swift 交互的更好的 Objective-C 框架，同时使您在项目中混用 Objective-C 和 Swift 的代码时能获得更好的性能。

+ __Swift 枚举类型现在可以通过 `@objc` 修饰来导出到 Objective-C 中__

    比如如下的 Swift 代码：

    ```swift
    @objc enum Bear: Int {
      case Black, Grizzly, Polar
    }
    ```

    导入到 Objective-C 中为：

    ```objc
    typedef NS_ENUM(NSInteger, Bear) {
      BearBlack, BearGrizzly, BearPolar
    };
    ```

+ __更加强大，一致的 `let` 关键字__ i

    新规则规定 `let` 常量必须在第一次使用前被初始化（和 `var` 变量类似），并且之后不能被重新赋值或者修改。

    这将允许我们写出如下的代码：

    ```swift
    let x : SomeThing
    if condition {
      x = foo()
    } else {
      x = bar()
    }
    use(x)
    ```

    在这之前为了达到这个效果，我们只能使用 `var` 来声明（尽管初始化后就再没有代码改动它）。同样的，常量属性也可以这样声明，然后再初始化器中初始化。

+ __更加的强大的可为空类型条件拆箱 `if let`__

     `if let` 语句现在能一次拆箱多个可为空变量，还可以在其中插入布尔条件表达式。这可以让您无需嵌套也能表达复杂的条件拆箱控制逻辑。

+ __新的原生的集合 `Set` 数据类型__

    `Set` 是一个和 `NSSet` 完美桥接的数据类型，用来表示一组无序的，唯一的数据。和 `Array`，`Dictionary` 一样，它在 Swift 中是一个值而非引用。

# 总结

我们由衷的欢迎您提交任何 bug 报告，希望所有常见的问题都在这个 beta 版得到解决。Swift 1.2 对于语言本身和其工具来说都是一次巨大的改进。它也引入了一些不向后兼容的改动，需要您对之前的代码做出修改，因此 Xcode 6.3 包含了一个移植工具来帮助您自动化这个过程。要使用该工具，请选 _Edit_ 菜单，然后选择 _Convert -> To Latest Swift Syntax..._ 选项。
