+++
date = "2015-09-30T07:07:44+08:00"
draft = true
title = "SWIFT NOTES - SWITCH STATEMETNS"

languages = ["Swift"]
platforms = ["MacOS", "iOS"]
+++

The Swift programming language provides us a really powerfull `switch`
statement.
<!--more-->

# `switch` Statement Feature List

1. no implicitly fall-through

    use `fallthrough` keyword to fallthrough next case explicitly

2. pattern listing

    enumerate multiple patterns in one `case` statement

3. interval matching

4. tuple matching & the wildcard pattern `_`

5. value binding

6. `where` clauses can specifiy more conditions

# An Example Demonstrating All the Features Above

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
