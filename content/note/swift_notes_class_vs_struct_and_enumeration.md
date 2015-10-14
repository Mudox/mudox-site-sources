+++
date      = "2015-10-13T03:10:24+08:00"
author    = "Mudox"
draft     = true
title     = "SWIFT NOTES - CLASS VS STRUCT & ENUM"

tags      = ["AppDev"]
languages = ["Swift"]
platforms = ["iOS", "MacOS"]
+++

Differences between Swift `class`s and `struct`s, `enum`s.
<!--more-->

The most distinct difference:

+ `class` is __reference__ type
+ `struct` & `enum` are __value__ types

In general, the common things they have:

1. can define __properties__, __methods__, __subscipts__
2. can define __initializers__
3. can be extended by __extensions__
4. can confirm to __protocols__

Features exclusively owned by `class`

1. __inheritance__
2. __deinitialization__
3. __reference counting__
4. __type casting__

Features exclusively owned by `structure`

1. __memeber-wise initializer__

Features exclusively owned by `enum`

1. __self assigning__
