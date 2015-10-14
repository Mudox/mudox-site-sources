+++
author    = "Mudox"
date      = "2015-04-13T16:26:59+08:00"
draft     = true
title     = "SWIFT NOTES - FUNCTIONS"

tags      = ["AppDev"]
languages = ["Swift"]
platforms = ["iOS", "MacOS"]
+++

Excerpts from the "Functions" section of the official docuemnt [《The Swift
Programming Language》](http://developer.apple.com/library/prerelease/ios/documentation/swift/conceptual/swift_programming_language/LexicalStructure.html)
<!--more-->

# Function Parameters

## Parameter names
A parameter name can have a __internal name__ and an __external name__ declared
in the form of: `external_name internal_name: type`.

Explicitly specify an external name for the first parameter to enable it when
calling.

```swift
func join(aString lhs: String, toString rhs: String) -> String {
  return lhs + rhs
}

println(join(aString: "Hello", toString: " World!"))
```

Swift compiler automatically generates external name from corresponding
internal names of all parameters except the 1st parameter.

Use `_` to suppress auto-generating external name: `_ internal_name: type`

```swift
func join(_ aString: String, _ toString: String) -> String {
  return aString + toString
}

println(join("Hello", " World!"))
```

## Parameters with default value

Parameters with default value of the form `[external_name/_] internal_name:
type = default_value` are **better** be placed at end of the parameter list.

```swift
func Foo(arg1: String, arg2: Int = 30, _ arg3: Bool) {
  ...
}

Foo("text", arg2: 1, true)
```

## Variadic parameters

Declare variadic parameter in form `name: type...`, which, in the function
body, is of type `[type]`.

**Only one** variadic parameter is allowed in a parameter list.

## Variable parameters

Prefix parameter names with keyword `var` to make them modifiable inside the
function body.

It is just another small syntactic sugar brought by Swift, the change made in
the function body will not propagate outside the function body.

## In-Out parameters

Prefix parameters names with keyword `inout` to propagate the change to the
parameter inside function body outside.

When specifying argument for `inout` parameters, prepend `&` to the argument
name to indicate that it could be modified during the function call.

In-out parameters

+ cannot have default values
+ cannot be variadic parameter
+ implies `var`, so cannot be marked as `var` or `let`

```swift
func swapTwoInts(inout a: Int, inout b: Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var a = 2
var b = 10
swapTwoInts(&a, &b)
println("after swapping, a = \(a), b = \(b)")
```

# Function Return Values

Functions without a defined return type return a special value of type
__Void__.  This is simply an empty tuple, in effect a tuple with zero elements,
which can be written as `()`.

You can use a tuple type (or a optional tuple) as the return type for a
function to return multiple values as part of one compound return value.

```swift
// wrap multiple return values in an optional tuple.
func minMax(array: [Int]) -> (min: Int, max: Int)? {
  return (1, 3) // no need to specify tuple element names again
}

if let minMax = minMax([1,2,3]) {
  // use name to fetch tuple element.
  println("min: \(minMax.min)\tmax: \(minMax.max)")

  // use index to fetch tuple elements.
  println("min: \(minMax.0)\tmax: \(minMax.1)")
}
```

# Function Types

A function type is made up of its' parameter types and return type.

In Swift, function is first class object, so feel free to use them as other
normal objects:

+ declare constants or variables to hold them, and call them latter.

+ passing them as arguments into functions.

+ return them from functions.

+ declare theme as type alias for convenience.

+ even nest them in another function.

```swift
// declare a type alias for long function types
typealias cmp = (Int, Int) -> Bool

func whichCmp(functionPassedIn: ()-> Bool) -> cmp {
  // nested fucntion definition
  func Foo(lhs: Int, rhs: Int) -> Bool {
    return false
  }

  func Hoo(lhs: Int, rhs: Int) -> Bool {
    return true
  }

  // function being returned
  return functionPassedIn() ? Foo : Hoo
}

func aFunc() -> Bool {
  return false
}

// function being passed in as an argument
whichCmp(aFunc)(1334, 234)
```
