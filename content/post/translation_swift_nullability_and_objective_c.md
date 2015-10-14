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

# 核心关键字: `_Nullable`，`_Nonnull`

这项新特性的核心就是两个关键字：`_Nullable`，`_Nonnull`。正如你所想的那样，所有 `_Nullable` 指针可以为 `NULL` 或者 `nil`，而所有 `_Nonnull` 指针不行。如果你违反了此规则，编译器将会发出警告。

```objc
@interface AAPLList : NSObject <NSCoding, NSCopying>
// ...
- (AAPLListItem * _Nullable)itemWithName:(NSString * _Nonnull)name;
@property (copy, readonly) NSArray * _Nonnull allItems;
// ...
@end

// --------------

[self.list itemWithName:nil]; // warning!
```

在您的 Objective-C 代码中，您几乎可以在任何可以用到 `const` 关键字的地方使用 `_Nullable`，`_Nonnull`，当然必须是修饰指针类型。Swift 还未常用的场景提供了更加漂亮的注释方式：对于那些简单的对象类型或者块类型的类成员声明，您可以使用 `_Nullable`，`_Nonnull` 非下划线版本来就注释他们。

```objc
- (nullable AAPLListItem *)itemWithName:(nonnull NSString *)name;
- (NSInteger)indexOfItem:(nonnull AAPLListItem *)item;
```

对于属性，您也可以使用非下划线的版本，这次不是放在属性名前面，而是把他们挪到属性列表中（括号里面）。

```objc
@property (copy, nullable) NSString *name;
@property (copy, readonly, nonnull) NSArray *allItems;
```

非下划线的版本看起来更加舒服，但是您任然需要把他们加到所有需要的头文件中。您可以使用监控区域（audited region）来简化这个过程，并让头文件变得更加干净。

# 监控区域（andited region)

为了简化新注释关键字的使用，您可以把您的 Objective-C 头文件中的某段代码标记为 __对可为空性进行监控__。在此代码段中，所有的简单指针类型都被编译器默认认为是不可能为空的，也就是 `_Nonnull`。这就大大减少了我们早前的示例中需要做的变动。

```objc
NS_ASSUME_NONNULL_BEGIN
@interface AAPLList : NSObject <NSCoding, NSCopying>
// ...
- (nullable AAPLListItem *)itemWithName:(NSString *)name;
- (NSInteger)indexOfItem:(AAPLListItem *)item;

@property (copy, nullable) NSString *name;
@property (copy, readonly) NSArray *allItems;
// ...
@end
NS_ASSUME_NONNULL_END

// --------------

self.list.name = nil;   // okay

AAPLListItem *matchingItem = [self.list itemWithName:nil];  // warning
```

处于安全性的考量，该规则有如下例外情况：

* `typedef` 类型别名语句，根据上下文，本身就是有确定的可为空性。它不受监控区域假设的影响。也就是说在监控区域内，`typedef` 语句定义的指针类型并不是默认为 `nonnull` 的，而是取决于定义它的原始类型。

* 复杂的指针类型必须明确的注释可为空性，不能省略。比如声明一个不可为空的指针只想一个可为空的对象的引用，必须用 `_Nullable id * _Nonnull` 来声明。

* `NSError` 是一个特殊的类型，它被用来通过参数返回错误。它总是一个指向一个可为空 `NSError` 对象指针的可为空指针，即 `_Nullable NSError * _Nullable`。

# 兼容性

那么如果您已经有了自己的 Objective-C 框架，现在要混合使用些类型安全么？当然，答案是肯定的。

- 现存的，已经编译好的 Objective-C 框架代码依然会继续工作，他们的应用二进制接口（ABI）并没有变（其实变化只发生在编译时）。这样意味着，老代码不会扑捉到错误的 nil 赋值。

- 当你转而使用新的 Swift 编译时，它能对您的使用旧框架代码的当前代码中不安全的行为发出警报。

- `nonnull` 不会影响编译器优化。如果为了向后兼容，您仍然可以对您可以在代码中加入检查指针是否为空的逻辑。

大体上您可以把 `nonnull` 和 `nullable` 当做断言或者异常捕捉特性来使用：违反协议是程序员本身的错误。毕竟是由您完全控制您的函数会返回什么值，因此在不该返回 `nil` 的函数中，您应该负责确保它不会返回空值，除非是为了向后兼容。

# 回到 Swift

现在我们已经在我们的 Objective-C 一端用上了可为空性注释，让我们看看 Swift 一端该跟着怎么变：

在用到注释之前：

```swift
class AAPLList : NSObject, NSCoding, NSCopying {
  // ...
  func itemWithName(name: String!) -> AAPLListItem!
  func indexOfItem(item: AAPLListItem!) -> Int

  @NSCopying var name: String! { get set }
  @NSCopying var allItems: [AnyObject]! { get }
  // ...
}
```

Objective-C 一端添加了注释之后：

```swift
class AAPLList : NSObject, NSCoding, NSCopying {
  // ...
  func itemWithName(name: String) -> AAPLListItem?
  func indexOfItem(item: AAPLListItem) -> Int

  @NSCopying var name: String? { get set }
  @NSCopying var allItems: [AnyObject] { get }
  // ...
}
```

是不是比以前清爽了？虽然只是细微的变化（少了几个类型后缀 `!`），但是这必将使您在 Swift 中使用以前的框架的心情更加愉快。

详情请参考 [Xcode 6.3 Release Notes](http://developer.apple.com/go/?id=xcode-6.3-beta-release-notes)
