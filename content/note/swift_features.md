+++
date = "2014-10-14T21:43:56+08:00"
draft = true
title = "SWIFT FEATURES"

languages = ["Swift"]
platforms = ["MacOS", "iOS"]
+++

During the learning of the Swift programming language, many of it's features
impressed me.
<!--more-->

# Powerful `switch` Statement

1. no implicitly fall-through

2. match multiple conditions in one case statement.

2. match against range.

3. match against tuple.

4. value binding.

5. `where` clause can provide more conditions.

6. `break` & `continue` can _jump_ further (to some label)

```swift
var aPoint = (x: 2, y: -1)
// labeled `swtich`
// NOTE: only loop statements and 'switch' statement can labeled.
theSwitch: switch aPoint {
// against tuple
case (0, 0):
  println("origin point")

// against multiple conditions separated by comma
case (1, 1), (2, 2):
  println("(1, 1) or (2, 2)")

// '_' means 'any value is ok'
case (_, 0):
  // the `break` here is just like the `pass` in python, acting as a
  // 'placeholder statement', nullifing this case branch.
  break

case (0, _):
  println("on the Y-axis")

// against range
case (-2...2, -2...2):
  println("on or in the 2x2 box")

// value binding
case (let x, -10):
  println("on the horizontal line y = -10, with a x value: \(x)")

// where clause
// NOTE: `let` can be replaced with `var` if you need to change the bound
// value afterwards.
case (0, var y) where y >= 0:
  y++    // mutable
  println("on the 1st or 2nd quadrant")

// value binding as a whole, which is an required exhaustive match
case let (x, y):
  theLoop: for i in 1..<100 {
    switch i {
      case let x where (x & 1) == 1: // a odd number
        break theSwitch     // jump further
      default:
        continue theLoop    // jump
    }
  }
}
```

# Closure -- Too Much Sugar!

The closure in Swift language adopts many syntactic sugar.

The basic full syntax of a closure is as follows:
```swift
{
  (parameters) -> retrunType in
  ... statements ...
}
```

Here is an example that uses the array's method `sorted` to sort an array of word.
```swift
var words = [ "Dolor", "eum", "id", "suscipit", "necessitatibus", "quod", "hic", "dignissimos" ]

let sortedWords = words.sorted({
  (lhs: String, rhs: String) -> Bool in
  return lhs < rhs
})
```

## Sugar #0 -- trailing closure

Often, closure parameter is placed last in parameter list. Swift thus provides
__trailing closure__, which means your can write the inline closure just
outside the parameter list, following the closing `)`.

Furthermore, if the closure is the only parameter, then the parenthesis can be
omitted.
```swift
// trailing closure
let sortedWords = words.sorted/*()*/ {
  (lhs: String, rhs: String) -> Bool in
  return lhs < rhs
}
```


## Sugar #1 -- return type inference

__return type__ can be inferred by swift compiler.
```swift
// omit return type
let sortedWords = words.sorted {
  (lhs: String, rhs: String) /*-> Bool*/ in
  return lhs < rhs
}
```

## Sugar #2 -- parameter type inference

__parameter types__ can be inferred by swift compiler as well.
```swift
// omit parameter types
let sortedWords = words.sorted {
  (lhs/*: String*/, rhs/*: String*/) /*-> Bool*/ in
  return lhs < rhs
}
```

## Sugar #3 -- parenthesis-less

Since no type annotation is needed, the __parenthesis__ can be omitted.
```swift
// omit parenthesis
let sortedWords = words.sorted {
  /*(*/lhs/*: String*/, rhs/*: String)*/ /*-> Bool*/ in
  return lhs < rhs
}
```

## Sugar #4 -- return statement inference

If the closure has one statement, then the __return__ statement can also be
inferred.
```swift
// omit 'return'
let sortedWords = words.sorted {
  /*(*/lhs/*: String*/, rhs/*: String)*/ /*-> Bool*/ in
  /*return*/ lhs < rhs
}

//then we got:
let sortedWords = words.sorted { lhs, rhs in lhs < rhs }
```

## Sugar #5 -- shorthand parameter name

Swift provides __shorthand parameter names__: $0 for the 1st parameter, $1 for
the 2nd parameter, and so on. And as an side effect, the whole `(parameters) ->
returType in` statement can be completely omitted
```swift
// use shorthand parameters, omit the whole 'in' statement
let sortedWords = words.sorted {
  /*(lhs: String, rhs: String) -> Bool in*/
  /*return*/ $0 < $1
}

// then we got:
let sortedWords = words.sorted { $0 < $1 }
```

## Sugar #6 -- operator as a closure

In swift, __operator__ is a function, which in turn is a special closure, so...
```swift
// comes operator!
let sortedWords = words.sorted(<)
```

# Fully-fledged Enumeration

In Swift, enumeration is fully-fledged type. You can associate different data
with each enumeration member, or define a raw type for enumeration.

## Flexible definition syntax

you can define more than one member a line.

## Type inference

## Associated Value

## Raw type

## Struct like enumeration

enumeration in Swift can have properties & methods.

enumeration, like struct in Swift, is value type (while class is reference
accounted type).
