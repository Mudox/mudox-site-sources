+++
date      = "2015-09-29T04:25:45+08:00"
author    = "Mudox"
draft     = true
title     = "SWIFT NOTES - COLLECTION TYPES"

tags      = ["AppDev"]
languages = ["Swift"]
platforms = ["iOS", "MacOS"]
+++

Notes about Swift collection types.
<!--more-->

# Array

Type notation:

* Full type name `Array<Element>`

* Shorthand & preferred type name `[Element]`

Initializes an array:

* with zero elements

```swift
// full syntax
let a = Array<Element>()

// short & preferred syntax
let a = [Element]()

// shortest syntax when the type inference is present
// `[]` here is the empty array literal with the assistence of type inference
let a: [Element] = []

func dealWith(array: [Element]) {
// ...
}

dealWith(array: [])
```

* with repeated default value

```swift
// full syntax
let a = Array<Double>(count: 5, repeatedValue: 0.0)

// short & preferred syntax
let a = [String](count: 10, repeatedValue: "default text")
```

* by concatenating two arrays

```swift
let a1 = [Int](count:3, repeatedValue: 0)
let a2 = [Int]()
let a = a1 + a2
```

* with an array literal

```swift
let a = ["Eggs", "Oil"]
let b: [Int] = [] // is equivalent to `let b = [Int]()`
```

# Set

Type notation:

* Full type name `Set<Element>`

* No shorthand type name for `Set` type

Initializes an set:

* with no element

```swift
// full syntax
let a = Set<Element>()

// shortest syntax when the type inference is present
let a: Set<Int> = [] // same as array

func dealWith(set: Set<Int>) {
// ...
}

dealWith(set: [])
```

* with an __array__ literal

```swift
// similar with array, but must be annotated as a Set type explicitly, thus
// force converting the array literal into a set
let a: Set<String> = ["Apple", "iOS", "Mac OS X"]

// annotation can be shortened by type inference
let a: Set = [1, 2, 3]
```

# Dictionary

Type annotation:

* Full type name `Dictionary<Key, Value>`

* Shorthand & preferred type name `[Key: Value]`

Initializes an array:

* with zero elements

```swift
// full syntax
let a = Dictrionary<Key: Value>()

// short & preferred syntax
let a = [Key: Value]()

// shortest syntax when the type inference is present
// `[:]` here is the empty dictionary literal with the assistence of type inference
let a: [Key: Value] = [:]

func dealWith(array: [Key: Value]) {
// ...
}

dealWith(array: [:])
```
