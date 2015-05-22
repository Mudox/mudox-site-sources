+++
date = "2015-05-15T15:50:26+08:00"
draft = true
title = "Swift 官博文章翻译 - 和指针类型交互"

tags      = ["Cocoa", "AppDev", "Translation", "Xcode"]
languages = ["Swift", "ObjC", "Chinese", "English"]
platforms = ["MacOS", "iOS"]
+++

原文链接：[Interacting with C Pointers](https://developer.apple.com/swift/blog/?id=6)

译者：Mudox

Objective-C 和 C 语言都使用到了指针类型。Swift 设计了一些数据类型，以尽可能的让您在与基于指针的 Cocoa API 交互时感到更加自然。Swift 能自动的帮您处理好很多常见的指针作为参数的情况。本文我们将好好看一看指针是怎么和 Swift 中的变量，数组和字符串类型交互的。
<!--more-->
