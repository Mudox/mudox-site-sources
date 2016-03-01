+++
date = "2016-01-17T13:34:39+08:00"
draft = true
title = "SWIFT NOTES - PATTERN MATCHING"

languages = ["Swift"]
platforms = ["MacOS", "iOS"]
+++

The original title was "SWIFT NOTES - SWITCH", after doing some further reading
and learning, I realized that it should be all about __pattern matching__.

But the whole story begins with the Swift switch statement for sure ...
<!--more-->

# Switch Statement Features

- No implicitly fall-through

    Unlike C, we must use the reserved word `fallthrough` to fallthrough into
    next case explicitly

- Pattern listing

    Enumerate multiple patterns in one `case` statement, separated by commas
    `,` implies __OR__ logical

- Use `where` clauses to narrow down the selection further, if a binding
  happens in the case.

- Matching must be exaustive

- The most significant feature is the way to match with target data, it is so
  versatile and powerful that it deserves a entire section to introduce it.

# Pattern Matching

Simply put, pattern matching is a mechanism (a group of syntaxes) provided by the
Swift language for you to matching with a target data (record) structually, and
if you want, extracts the data (field(s)) in interest at the same time.

Currently Swift defines 7 types of pattern matching, by proper use of
which you can write more clear, succinct code, getting rid of spaghetti of
`if` branches.

1. Match traditionally -- identifier matching

    value == value matching, the most common one.

2. Wild match with a value -- the wildcard pattern `_`

    The `_` matches any thing even `nil`.

    Suffixing `_` with a `?` (`_?`) narrows the match range down to only
    those non-nil optionals. (i.e when matching with optional values, `nil` &
    `_?` are mutually complementary).

3. Match with optional -- value binding matching

    matching a non-nil optional and at the same time unwrap and bind a
    identifier to the inner value

4. Match with tuple -- tuple matching

    `let` or `var` key can appear member-wise or appear outside once

5. Match with `enum` case -- `enum` case matching

6. Math with casted type -- type-casting matching

    `case is AType` performs a type casting behind to see if succeed and
    discard the result.

    `case let n as AType` performs the type casting and bind the result to
    `n` for use in the case body.

7. Match with expression -- expression matching

    The most flexible one that enable you to define you own pattern.

    Match with types which implement the `~=` operator, just like `===`
    operator in Ruby, where `case` things appear as the left hand side
    operand, `which` things as right hand side operand.

    There has been default implementations of `~=` for some types such as:
    Range<>

    __EXCEPTION__: overloading `~=` with a tumple as the left hand side incur
    panic in `switch` statement.

Given the aboves you could known that Swift encourages you to use optionals,
tuples and `enum`s which are smoothly fitted with pattern matching mechanism to
produce a terse and clear codebase.


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

// a expression matching nested in tuple matching
case (-2...2, -2...2):
  println("on or in the 2x2 box")

// value binding nested in tuple matching
case (let x, -10):
  println("on the horizontal line y = -10, with a x value: \(x)")

// where clause
// NOTE: `let` can be replaced with `var` if you need to change the bound
// value afterwards.
case (0, var y) where y >= 0:
  y++    // mutable
  println("on the 1st or 2nd quadrant")

// value binding all members
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

# References

- [Patterns, what the official say](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Patterns.html#//apple_ref/doc/uid/TP40014097-CH36-ID419)

- [Match me if you can](http://appventure.me/2015/08/20/swift-pattern-matching-in-detail/)

- [Swift's pattern matching switch statement](http://austinzheng.com/2014/12/16/swift-pattern-matching-switch/)

- [Custom pattern matching in Swift](http://austinzheng.com/2014/12/17/custom-pattern-matching/)
