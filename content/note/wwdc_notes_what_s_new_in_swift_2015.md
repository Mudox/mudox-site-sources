+++
date = "2015-06-12T12:34:47+08:00"
draft = true
title = "WWDC NOTES - WHAT'S NEW IN SWIFT (2015)"

tags      = ["Cocoa", "AppDev"]
languages = ["Swift", "ObjC"]
platforms = ["MacOS", "iOS"]
+++

NOTES for What'S New in Swift (2015) from WWDC15.

<!--more-->

# Fundamentals

---

## Print `enum`s

```swift
enum Animals {
    case Dog, Cat, Troll, Dragon
}

let a = Animals.Dragon
print(a) // get 'Animals.Dragon' instead of frustrating '(Enum Value)'
```

## Associated Values in `enum`s

```swift
// a stronger version of C union
enum Either<T1, T2> {
  case First(T1)
  case Second(T2)
}
```

## Recursive `enum`s

```swift
enum Tree(T) {
  case Leaf(T)
  indirect case Node(Tree, Tree)
}
```

## `do` Statement

```swift
do {
    // new containing scope
} catch ... {

// for `do-while` in other languages, use `repeat` to avoid ambiguity
repeat {
    // repeating code lines
} while ...
```

## Options Sets

```swift
// before swift 2.0
viewAnimationOpetions = .Repeat | .CurveEaseIn | .TransitionCurlUp
viewAnimationOpetions = nil
if viewAnimationOpetions & .TransitionCurlUp != nil {

// in swift 2.0
viewAnimationOpetions = [.Repeat, .CurveEaseIn, .TransitionCurlUp]
viewAnimationOpetions = []
if viewAnimationOpetions.contains(.TransitionCurlUp) {

// new way of defining OptionSetType derived option types
struct MyFontStyle : OptionSetType {
    let rawValue: Int
    static let Bold          = MyFontStyle(rawValue: 1)
    static let Italic        = MyFontStyle(rawValue: 2)
    static let Underline     = MyFontStyle(rawValue: 4)
    static let Strikethrough = MyFontStyle(rawValue: 8)
}

myFont.style = []
myFont.style = [.Underline]
myFont.style = [.Bold, .Italic]

if myFont.style.contains(.Strikethrough) {
```

## Functions and Methods

all `func` declarations are uniform:

- First argument is implied by the base function name

- Labels are used for subsequent arguments

- No special rules for defaulted parameters

- `#` argument syntax has been removed

## Diagnostic

- New fix-it helps you add `mutating` ahead of mutating methods

- New Warnings

    + `var` defined variable never mutated

    + `let` defined constant never used

    + unused `sort()` result, use in-place version `sortInPlace()`

## SDK Improvements

Adoption of new features and best practices:

+ Nullability qualifiers

+ Objective-C typed collections

+ `NS_ENUM`, `NS_OPTIONS`, instancetype, @property, etc

see sessions:

1. __Swift and Objective-C Interoperability__ (2015)

1. __What's New in Cocoa__ (2015)

for more details

## Unit Testing and Access Control

see sessions:

1. __What's New in Xcode__ (2015)

1. __UI Testing in Xcode__ (2015)

for more details

## Rich Comments

see sessions:

1. __Authoring Rich Playgrounds__ (2015)

for more details

## Other Features

+ Default implementations in protocols

+ C function pointers + closures

+ Recursive nested functions

+ `if`/`do` labeled break

+ SIMD Vectors

+ Mirrors API

+ `readline()`

+ `@nonobjc`

see sessions:

1. __The Swift Programming Language__ (Swift 2.0)

2. __Xcode 7 release notes__

for more details

# Pattern Matching

---

## `guard` Statement for Early Exit

```swift
guard let ...
      let ... else {
}
```

> Any variables or constants that were assigned values using an optional
> binding as part of the condition are available for the rest of the code block
> that the guard statement appears in.

> The `else` branch must transfer control to exit the code block that that
> guard statement appears in. It can do this with a control transfer statement
> such as `return`, `break`, or `continue`, or it can call a function or method that
> dosen't return, such as `fatalError()`.

## `case` Uniformly Supported in Control Flow Statements

    ```swift
    // switch with only one case you want to handle

    // before swift 2.0
    switch bar() {
    case .MyEnumCase(let value) where value != 42:
        doThing(value)
    default: break
    }

    // in swift 2.0
    if case .MyEnumCase(let value) = bar() where value != 42 {
        doThing(value)
    }
    ```

    for now there are 4 kind of case statements

    1. switch case

    1. while case

    1. if case

    1. guard case

    1. for-in case

## `for ... in` Filtering

    ```swift
    // before swift 2.0
    for value in mySequence {
      if value != "" {
        doThing(value)
      }
    }

    // in swift 2.0
    for value in mySequence where value != "" {
      doThing(value)
    }
    ```

# API Availability Checking

---

```swift
if|guard #available({platform name} {version}, ..., *) {
  // statements to execute if the APIs are available
} else {
  // fallback statements to execute if the APIs are unavailable
}
```

# Protocol Extensions

---

```swift
extension Array {

}
```

see sessions:

1. __Protocol Oriented Programming in Swift__ (2015)

for more details

# Error Handling

---

## 3 New Keywords and 1 statements

1. Fail-able functions `throw` errors instead of pass out `inout error: NSError?` (or `NSErrorPointer`)

1. Use `try` to mark & invoke throw-able functions

1. Use `try!` to assert that fail-able function must not fail.

1. Use `do {...} catch ... {}` construct to try & catch errors

```swift
func mayFail() throw {
  ...
  throw {throw-able object}
  ...
}

// mark & invoke a failable function
try mayFail()

// throwing out an error is just like assertion failed
try! mayFail()

// do {
  try mayFail()
} catch ErrorEnum.ErrorType {
  // catch pattern matching
} catch let error {
  // catching & binding
} catch {
  // catch everything
}
```

## `ErrorType` protocol

Any type that conforms to `ErrorType` can be thrown and caught

- `NSError` already conforms to `ErrorType`

- Can make your own types conform as well

## `enum` is Great for Groups of Related Errors

- Can carry data in a payload

- Compiler handles protocol conformance details automatically

```swift
enum DataError : ErrorType {
case MissingName
case MissingYear
// add more later
}

func processSale(json: AnyObject) throws {
guard let buyerJSON = json["buyer"] as? NSDictionary {
  throw DataError.MissingBuyer
}
let buyer = try processPerson(buyerJSON)

guard let price = json["price"] as? Int {
  throw DataError.MissingPrice
}

return Sale(buyer, price)
}
```

## `defer` actions

simlilar to the `defer` keywords in Go language.

```swift
func processSale(json: AnyObject) throws {
  delegate?.didBeginReadingSale()
  defer { delegate?.didEndReadingSale() }

  guard let buyerJSON = json["buyer"] as? NSDictionary {
    throw DataError.MissingBuyer
  }
  let buyer = try processPerson(buyerJSON)

  guard let price = json["price"] as? Int {
    throw DataError.MissingPrice
  }

  return Sale(buyer, price)
}
```
