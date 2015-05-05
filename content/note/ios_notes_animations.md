+++
date = "2015-05-03T13:43:56+08:00"
draft = true
title = "iOS NOTES - iOS ANIMATIONS"

tags      = ["Cocoa", "AppDev"]
languages = ["Swift", "ObjC"]
platforms = ["MacOS", "iOS"]
+++

# iOS Animation API Clusters From Top to Bottom

In general there are 2 groups of APIs: the view based animation APIs & the
underlying Core Animation APIs that is backing the former.

1. UIView `begin...` & `commit...` style APIs

    They are the oldest APIs before block was introduced into the framework,
    with `begin...` to start recording an animation, a bunch of
    `setAnimation...` to be called subsequently to set configure various
    animations detailes, and then ends with a `commit...` call.

2. UIView block based APIs

    In iOS 4.0, block was introduced to facilitates the creation of UIView
    animations (replacing the old `begin...` & `commit` APIs).

    Note that during the animation block, you can still call the
    `setAnimation...` functions to tweak details of animation.

    The full form of the function accepts 5 arguments:

      1. Duration

      2. Delay

      3. Animation options

      4. The animation block

      5. Completion block

    The block based animation is just like creating, configuring & adding
    `CABasicAnimation` to layers of each involved view in the block.

3. UIView spring Animation

    As its name suggests, it can do some kind of _underdamped oscillation_. It
    arguments list is similar to full form of block based function, with two
    more paramters:

      1. Damping ratio

      2. Initial velocity

4. UIView view transition APIs

    2 convenient methods were added to faciliate the common occasions when you
    want to animation subview changes in one view a whole, or replacing one
    view with another.

5. UIView key frame Based APIs

    It only have 2 methods, call `animateKeyframes...` to start the whole
    animation, and within a block, call `addKeyframe...` multiple times with
    apprioate relative timming setting to layout the key frames duraing the
    whole animation.

    Using it is just like adding `CAKeyframeAnimation` to the layer of involved
    views in the block.

6. Core Animation

    Provided by the _Quartz Core_ framework from _Media Layer_. It is the basis
    of everything mentioned above.

    It provides concepts of layer, animcation object, animation transaction,
    etc. When you can not achieve effect you want through APIs listed above,
    come for it.
