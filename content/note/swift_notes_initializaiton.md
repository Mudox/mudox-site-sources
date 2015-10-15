+++
date      = "2015-10-13T03:07:00+08:00"
author    = "Mudox"
draft     = true
title     = "SWIFT NOTES - INITIALIZATION"

tags      = ["AppDev"]
languages = ["Swift"]
platforms = ["iOS", "MacOS"]
+++

Notes about Swift initialization
<!--more-->

Syntax:

```swift
// non-failable initializer
init() {
    ...
}

// failable initializers
init?() {
    ...
}

init!() {
    ...
}
```

Notes:

+ Unlike normal function & methods, the 1st parameter gets a external name
  automatically as well as the following parameters. Use `_` to suppress the
  external name if you want.
+ Unlike Objective-C initializers, Swift initializers do not return a value.

# Setting Initial Values for Stored Properties

There are 3 ways a stored property can get an initial value:

1. Set value in initializer
2. Set default value in property declaration
3. Optional stored properties get `nil` as default value, if given no default value

Notes:

+ Specifying a default value is preferred than set initial value in initializer.
+ Property observers will __NOT__ be triggered by initial value setting.
+ Through closure or global function invocation syntax, you can make the
  default value setting more flexible.

```swift
class Foo {
    // DO NOT forget the trailling `()`, otherwise the closure/function itself
    // would be assigned to as the default value.

    let name: String = {
    ...
    }()

    var id: Int = GenerateRandomID(...)
}
```

## Constant stored property iniitialization

For constant stored property, if you given a default value in definition,
then it's initialization is complete, you CAN NOT modify it's value later
in initializers.

You can define a constant stored property with no default value, and set an
initial value latter in the initializers

For class instances, a constant stored property can only be modified during
initialization by the class that introduces it. It cannot be modified by a
subclass.

# Compiler Synthesized Initializers

1. __default initializer__ for `struct` & `class`

    2 prerequisite:

    1. all stored property are given default values
    2. defines no custom initializer

2. __memberwise initializer__ for `struct`

    2 prerequisite

    1. defines no custom initializer
    2. defines at least one variable stored property or constant stored property
       that is not given a default value (so there is a necessity for the initializer)

3. __rawValue initializer__ for `enum` with associated value

    it is a failable initializer `init?(rawValue: T) {...}`

# Initializer Delegation

Use `self.init(...)` to delegate initialization task to other initializers.

Since defining custom initializer suppresses default & memberwise initializer
synthesization, you can define custom initializers in extension, then delegate
to default or memberwise initializer in the body.

`class` can define 2 kinds of initializers:

1. designated initializers -- `init(...)`
2. convenience initializers -- `convenience init(...)`

## 3 rules for class initializer delegation

1. A designated initializer must call a designated initializer from its
   immediate superclass.
2. A convenience initializer must call another initializer from the same class.
3. A convenience initializer must ultimately call a designated initializer.

put simply:

1. convenience initializer delegation across -- `init(...)`
2. designated initializer delegation upwards -- `super.init(...)`

## Two-Phase Initialization

4 safty checks that Swift compiler perform to ensure 2-phase initialization:

1. In designated initializer, initialize all local stored properties before
   delegate up
2. In designated initializer, delegate up before modifying any inherited stored
   properties
3. In convenience initializer, delegate across before modifying any property
4. In any initializers, only after the 1st-phase initialization is complete
   then it can
    - call any instance methods or subscripts
    - read any instance properties
    - reference `self` as an value

## Initialization inheritance & overriding

Unlike subclasses in Objective-C, Swift subclasses do __NOT__ inherit their
superclass initializers by default. Only when certain rules are satisfied can
certain initializers be inherited to subclasses.

Do __NOT__ write the `override` modifier when providing a matching
implementation of a superclass __convenience initializer__ (_because it can not
delegate up to it counterpart in superclass, the implementation is not
considered as a overriding_)

### 2 prerequisites for automatic initializer inheritance

1. if your subclass doesn’t define any designated initializers, it
   automatically inherits all of its superclass designated initializers.
2. If your subclass provides an implementation of all of its superclass
   designated initializers—either by inheriting them as per rule 1, or by
   providing a custom implementation as part of its definition—then it
   automatically inherits all of the superclass convenience initializers.

# Failable Initiializer

Use `init?() {...}` or `init!() {...}` to define a failable initializer

Use `return nil` to fail the initialization process though the Swift
initializer dose not return any value

When defining failable initializer:

+ for `struct` & `enum`, it can fail before all stored properties are given a
  valid initial value.
+ for `class`, only after the 1st initialization is completed can it fail.

you can use constant implicitly unwrapped optional property to satisfy rule #2
without first assign an valid initial value to it.

