+++
date = "2015-09-30T07:11:10+08:00"
draft = true
title = "SWIFT NOTES - GUARD"

languages = ["Swift"]
platforms = ["MacOS", "iOS"]
+++

`guard` from Swift is a branching statement similar to `if`, but have its own
distinct use cases.
<!--more-->

1. Optional bound variables/constants in condition are visible after its' `guard` statement.

2. Always needs a `else` branch.

3. `else` branch must jump out of the enclosing block of its' `guard` statement. You can do it:

    * through keywords: `break`, `continue`, `return`, `throw`

    * by calling a function or method that doesn't return, e.g. `fatalError()`.
