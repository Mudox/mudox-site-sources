+++
date = "2015-04-14T08:43:56+08:00"
draft = true
title = "SWIFT NOTES - CLOSURE"

languages = ["Swift"]
platforms = ["MacOS", "iOS"]
+++

Thanks to the host of technologies provided by the Swift compiler, the closure
comes with a bunch of syntactic sugars that could sweet you to diabetes.
<!--more-->

The full syntax of a closure:
```swift
{
  (parameters) -> retrunType in
  ... statements ...
}
```

Here is an example that uses the array's method `sorted` to sort an array of
word.

```swift
var words = [ "Dolor", "eum", "id", "suscipit", "necessitatibus", "quod", "hic", "dignissimos" ]

let sortedWords = words.sorted({
  (lhs: String, rhs: String) -> Bool in
  return lhs < rhs
})
```

As the sugars introduced in one by one, we will cut the lines above into an
incredibly one-liner.

# Sugar #0 -- trailing closure

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

# Sugar #1 -- return type inference

__return type__ can be inferred by swift compiler.
```swift
// omit return type
let sortedWords = words.sorted {
  (lhs: String, rhs: String) /*-> Bool*/ in
  return lhs < rhs
}
```

# Sugar #2 -- parameter type inference

__parameter types__ can be inferred by swift compiler as well.
```swift
// omit parameter types
let sortedWords = words.sorted {
  (lhs/*: String*/, rhs/*: String*/) /*-> Bool*/ in
  return lhs < rhs
}
```

# Sugar #3 -- parenthesis-less

Since no type annotation is needed, the __parenthesis__ can be omitted.
```swift
// omit parenthesis
let sortedWords = words.sorted {
  /*(*/lhs/*: String*/, rhs/*: String)*/ /*-> Bool*/ in
  return lhs < rhs
}
```

# Sugar #4 -- auto return for single expression closure

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

# Sugar #5 -- shorthand parameter name

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

# Sugar #6 -- operator as a closure

In swift, __operator__ is a function, which in turn is a __special closure__, so...
```swift
// comes operator!
let sortedWords = words.sorted(<)
```

