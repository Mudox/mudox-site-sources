+++
date = "2015-02-07T09:24:33+08:00"
draft = true
title = "ERROR COLLECTION - IOS"

tags      = ["Dev"]
platforms = ["MacOS"]
languages = ["OC", "Swift"]
series    = ["Error"]
+++

Errors that I collected day by day, when developing iOS apps.
<!--more-->

* Specifying an invalid frame size (i.e. 0 width or 0 height), can make
  UIView's such as UISlider unresponsive to user interaction.

* Always wrap multiple statements following a `switch case:` in a curly brace,
  where we can even put a variable declaration in it.

* Should __NOT__ assgin one instance of `UIImage` to multiple
  `UITextField.leftView` or `UITextField.rightView` properties.

* UIImageView, by defaults, is __NOT__ userInteractionEnabled, hence sub views
  under them may not receive touch events.

* When creating outlets for UILabel views, __DO NOT__ name the property
  "title", cause the super class of your view controller `UIViewController`
  itself has a property 'title', it will incur exception at runtime time.

* Remember to clean dead connnection recorded by storyboards for controls &
  views in interface builder window.

* Dragging an element with <Atl> key pressed, will copy it's attributes as well as
  it's connections and other info set in the interface builder and uitility
  panes.

* When presenting a view controller from a content view controller embeded in a
  __navigation view controller__, it is the navigation view controller, rather
  than the embeded content view controller, which is __presenting__ the view
  controller.

* When customizing table view cells, __DOT NOT__ use `UIButton` to cover the cell for
  triggering the segue, which would bring a function redundant and thus
  complicates things.

* __DO NOT__ auto-layout a subview within a auto-layout'ed `UIScrollView` when
  you plan to perform zooming operation in it.


* After getting a reused cell, make sure all its' states get reset to the current
  value or the default value, otherwise the remained states set by last usage
  would mess your up.

* setting `clipsToBounds` to true will clips layer shadow off.
