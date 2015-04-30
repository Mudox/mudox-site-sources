+++
date = "2015-04-12T14:43:56+08:00"
draft = true
title = "iOS NOTES - CASTING"

tags      = ["Cocoa", "AppDev"]
languages = ["Swift", "ObjC"]
platforms = ["MacOS", "iOS"]
+++

Collect all my gain from study & using Swift's casting mechanism here.
<!--more-->

First defining a sample class hierarchy:

```swift
class SuperClass {
  func say() {
    println("super class")
  }
}

class Subclass: SuperClass {
  override func say() {
    println("subclass")
  }
}
```

# 3 Kinds of Castings

1. Natural Casting

    Used in __up-casting__ (i.e. casting from a sub-class instance to a super
    class instance)

    ```swift
    var a = SubClass()
    var b = a as SuperClass
    ```

2. Unconditional Casting (or forced casting)

    Used in __down-casting__ (i.e. the contrary of the above).

    When the casting failed, it would incur a panic.

    Use it when you are confident about the down-casting.

3. Conditional Casting

    Used in __down-casting__, but it always returns optionals whether succeed
    or fail, that means when not
    applicalbe, instead of emitting a panic, it returns nil.

Conclusion:

* Natural casting is used in _always-succeed_ castings.

* Conditional & Unconditional castings are used in _might-fail_ castings.

# 2 Operator for Casting

1. The `is` operator

2. The `as` operators - `as`, `as?`, `as!`

# Special casting scenarios in practice

## Protocol Casting

In Swift the relationship between a protocol and the classes adopting that
protocol is like the relationship between a super class and its' sub-classes.
Hence casting a protocol object, such as the `AnyObject` to its' underlying
class is regarded as a down-casting.

```swift
import UIKit // import AppKit

let a: AnyObject = "String"
let b: a as! String
```

There are 3 special types: `Any`, `AnyObject`, `AnyClass`.

By tracing the source code, you would find the following:
```swift
/// The protocol to which all classes implicitly conform.
///
/// When used as a concrete type, all known `@objc` methods and
/// properties are available, as implicitly-unwrapped-optional methods
/// and properties respectively, on each instance of `AnyObject`.
@objc procotol AnyObject {}

/// The protocol to which all class types implicitly conform.
///
/// When used as a concrete type, all known `@objc` `class` methods and
/// properties are available, as implicitly-unwrapped-optional methods
/// and properties respectively, on each instance of `AnyClass`.
typealias AnyClass = AnyObject.Type

/// The protocol to which all types implicitly conform
typealias Any = protocol<>
```
There exists a prerequisite for the rules all above: the `Foundation` framework
must be imported. (Usually, you import `UIKit` or `AppKit`, which implicitly
import `Foundation` framework). Only then can swift compiler be able to
recognize the `@objc` keyword, and have Objective-C type bridging ability.

## Optional AnyObject Collection Casting

For a optional of Collection of AnyObject that reference objects of the same
class (or super class) T, can be [un]conditionally casted to \[T\] (without
being wrapped in optional anymore)

```swift
import UIKit // import Appkit

// optional array of String.
let a: [AnyObject]? = ["Newyork", "London", "Peking"]
let b = a as! [String] // succeed.

// optional array of mixed object that have no common super class.
let a: [AnyObject]? = ["Newyork", 1983, 3.14, false]
let b = a as! [String] // fail: not all element are of String.

// optinal array of mixed objects that derived from the same super class.
let a: [AnyObject]? = [Subclass(), SuperClass(), SuperClass(), Subclass()]
let b = a as! [Subclass] // succeed: not all element are of String.

// implicitly unwrapped optional dictionary with String typped keys and Int typed values.
let a: [NSObject: AnyObject]! = ["id1": 32, "id2": 66]
if let b = a as? [String: Int] {
  println(b)
}
```

In the code list above, the String is a structure type in Swift (no a class
type), but it can also be referenced by a `AnyObject` instance. The rules come
from the following excerpt from "Using Swift with Cocoa and Objective-C"
official document:

> An object is AnyObject compatible if it is an instance of an Objective-C or
> Swift class, or if the object can be bridged to one.

There exist several swift - Objective-C type bridging depicted as follows:

![Siwft - Objective-C Bridging](../../../note/swift_objc_bridging.svg)

Hence, back to the code listing above, the Swift type `String` can be bridged
to NSString `Foundation` class, then it is `AnyObject` compatible.


In practice, there exists quit a few occasions that you need to cast optional
collections to type specific Swift collections to utilize their underlying
methods or properties.

For example, when you invoke the Objective-C APIs that return `NSArray`,
`NSDictionary`, `NSSet`, you would get `[AnyOject]!` `[NSObject: AnyOject]!`,
`[NSObject]!` respectively, you could cast [un]conditionally to a more concrete
Swift collection type before you access the individual elements within they.

When you use `as!` (the unconditional casting), you got an unwrapped collection
in one line of code.


```swift
let asset: AVURLAsset = ...
for meta in asset.commonMetadata as! [AVMetadataItem] {
  switch meta.commonKey {
  case AVMetadataCommonKeyTitle:
    item.title = meta.stringValue
  case AVMetadataCommonKeyArtist:
    item.artist = meta.stringValue
  case AVMetadataCommonKeyAlbumName:
    item.albumName = meta.stringValue
  case AVMetadataCommonKeyArtwork:
    switch meta.value {
    case let data as NSData:
      item.artwork = UIImage(data: data)
    case let dict as [NSObject: AnyObject]:
      item.artwork = UIImage(data: dict["data"] as! NSData)
    default:
      assert(false, "Invalid metadata value type")
    }
  default:
    break
  }
}
```
