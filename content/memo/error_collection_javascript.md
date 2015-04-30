+++
date = "2014-11-07T09:24:33+08:00"
draft = true
title = "ERROR COLLECTION - JAVASCRIPT"

platforms = ["Web"]
languages = ["JavaScript"]
series    = ["Error"]
+++

Errors that I collected day by day when writing the JavaScript language.
<!--more-->

* when assign a function to a event property, dot not appending `()` to the function name.

```javascript
window.onload = init/*()*/

function init() {
  // ...
}
```

* appending `()` to a property name.

```javascript
var x = Math.floor(Math.random() * canvas.width/*()*/
```

* `$(this)` not `$("this")`.
