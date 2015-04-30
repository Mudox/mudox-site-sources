+++
date = "2015-04-30T15:03:56+08:00"
draft = true
title = "Swift 官博文章翻译 - 可为空性和 Objective-C"

tags      = ["Cocoa", "AppDev", "Translation"]
languages = ["Swift", "ObjC", "Chinese", "English"]
platforms = ["MacOS", "iOS"]
+++

原文链接：[Nullability and Objective-C](https://developer.apple.com/swift/blog/?id=25)

译者：Mudox

Swift 语言的一个很棒的特性就是它能透明的和 Objective-C 代码互操作，不管是系统提供 Objective-C 框架还是那些你自己写的代码都能。然而，在 Swift 中，可为空的值与不可为空的值引用之间使用明显区别的。比如说 `NSView` 和 `NSView?` 在 Swift 中是两个截然不同的类型，但在 Objective-C 中他们都用 `NSView *` 表示。由于 Swift 无法判断 `NSView *` 到底是可为空的引用还是不可为空的引用，所以 Swift 把此类型转换为一个隐式拆箱的可为空类型（implicitly unwrapped optional）—— `NSView!`

在此前的 Xcode 版本中，Apple 公司对一些框架做了特殊处理，以让它们在 Swift 被转换为适当的可为空类型。Xcode 6.3 引入了一个新的 Objective-C 特性：可为空性注释（nullability annotation），是的程序也能对自己的代码做出同样的处理。
<!--more-->

# 核心关键字: `__nullable`，`__nonnull`

这项新特性的核心就是两个关键字：`__nullable`，`__nonnull`。正如你所想的那样，所有 `__nullable` 指针可以为 `NULL` 或者 `nil`，而所有 `__nonnull` 指针不行。如果你违反了此规则，编译器将会发出警告。

```swift
@interface AAPLList : NSObject <NSCoding, NSCopying>
// ...
- (AAPLListItem * __nullable)itemWithName:(NSString * __nonnull)name;
@property (copy, readonly) NSArray * __nonnull allItems;
// ...
@end

// --------------

[self.list itemWithName:nil]; // warning!
```

在您的 Objective-C 代码中，您几乎可以在任何可以用到 `const` 关键字的地方使用 `__nullable`，`__nonnull`，当然必须是修饰指针类型。Swift 还未常用的场景提供了更加漂亮的注释方式：对于那些简单的对象类型或者块类型的类成员声明，您可以使用 `__nullable`，`__nonnull` 非下划线版本来就注释他们。

```swift
- (nullable AAPLListItem *)itemWithName:(nonnull NSString *)name;
- (NSInteger)indexOfItem:(nonnull AAPLListItem *)item;
```

对于属性，您也可以使用非下划线的版本，这次不是放在属性名前面，而是把他们挪到属性列表中（括号里面）。

```swift
@property (copy, nullable) NSString *name;
@property (copy, readonly, nonnull) NSArray *allItems;
```

非下划线的版本看起来更加舒服，但是您任然需要把他们加到所有需要的头文件中。您可以使用监控区域（audited region）来简化这个过程，并让头文件变得更加干净。

# 监控区域（andited region)

# 兼容性

# 回到 Swift
