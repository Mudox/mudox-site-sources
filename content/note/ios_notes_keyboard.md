+++
author    = "Mudox"
date      = "2015-04-08T16:19:59+08:00"
draft     = true
title     = "iOS NOTES - KEYBOARD"

tags      = ["Cocoa", "AppDev"]
languages = ["ObjC", "Swift"]
platforms = ["iOS"]
+++

Handle iOS keyboard poppu & resignment gracefully.
<!--more-->

# UIWindow provide 6 keyboard related notifications

+ `UIKeyboard[Will/Did]ShowNotification`
+ `UIKeyboard[Will/Did]HideNotification`
+ `UIKeyboard[Will/Did]ChangeFrameNotification`

After playing with these notifications above, I found:

1. When you want to move obscured contents or views to above the keyboard, put
   the frame adjustment code in \*__Will__\* notifications, because the handler
   methods seems to be invoked within the same animation block that provides
   the keyboard revealing animation.

2. If you are only interested in tracing keyboard's frame (more specifically the
   height) during keyboard's presence, monitoring
   `UIKeyboardWillShowNotification` seems enough, no need to monitoring
   `UIKboardWillChangeFrameNotification` additionally.

3. The frame size stored in `UIKeyboardFrameBeginUserInfoKey` and
   `UIKeyboardFrameEndUserInfoKey` keys will only differ after keyboard is
   first shown and before it is hidden. When the keyboard is first shown or is
   resigned, the `Begin` or `End` frame is equal.

# Strategies for move contents above the keyboard:

## For contents embedded in `UISCrollView`s

Way #1 -- Adjust the bottom edge inset value of the containing scroll view's
contentsInset property and scroll active view into visible area using
`scrollRectToVisible: animated:` method.

Way #2 -- Adjust containing scroll view's contentSize & contentOffset
properties.

No matter which way above you choose, remember to adjust
`scrollIndicatorInsets`'s bottom edge inset value to make the indicator fully
un-obscured from the keyboard.

## For contents outside any `UIScrollView`

Recalculate and set its' frame.origin.y value in
`UIKeyboardWillShowNotification` handler method, and the movement will be
animated along with the revealing of keyboard perfectly.

```swift
func handleKeyboardNotification(notify: NSNotification) {
  let value = notify.userInfo?[UIKeyboardFrameEndUserInfoKey] as NSValue
  let keyboardHeight = value.CGRectValue().height

  switch notify.name {

  case UIKeyboardWillShowNotification:
    theViewToMove.frame.origin.y = self.view.bounds.height - keyboardHeight - theViewToMoveMargin - theViewToMove.bounds.height
    theScrollViewToAdjust.contentInset.bottom = keyboardHeight
    itemsTable.scrollIndicatorInsets.bottom = keyboardHeight

  case UIKeyboardWillHideNotification:
    theViewToMove.frame.origin.y = self.view.bounds.height - theViewToMoveMargin - theViewToMove.bounds.height
    theScrollViewToAdjust.contentInset.bottom = 0.0
    itemsTable.scrollIndicatorInsets.bottom = 0.0 // the default value

  default:
    assert(false)
  }
}
```

# References:

* [Moving Contents That is Located Under the Keyboard in Text Programming Guide for iOS](https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html#//apple_ref/doc/uid/TP40009542-CH5-SW7)

* [UIWindow Class Reference](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIWindow_Class/)
