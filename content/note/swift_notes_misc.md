+++
date      = "2015-10-13T19:18:08+08:00"
author    = "Mudox"
draft     = true
title     = "SWIFT NOTES - MISC"

tags      = ["AppDev"]
languages = ["Swift"]
platforms = ["iOS", "MacOS"]
+++

Miscellaneous knowledges I collected when learning Swift language.
<!--more-->

Lazily stored closure property capturing `self`

Using implicitly unwrapped optional property to satisfying 2-phase
initialization

+ it is given a default value `nil` automatically, it can be assigned a real
  initial value after delegation in initializer
+ after initialization, it can be used as a non-optional property

Only allowed in one direction

* override read-only property -> read-write property
* override failable initialiser -> unfailable initializer
* override designated initializer -> convenience initializer
* failable initializer can delegate -> failable/unfailable initializer
