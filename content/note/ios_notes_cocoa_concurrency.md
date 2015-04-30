+++
date        = "2014-09-24T22:18:21+08:00"
draft       = true
title       = "iOS NOTES - COCOA CONCURRENCY"

tags        = ["Cocoa", "Concurrency"]
languages   = ["ObjC", "Swift", "C"]
platforms   = ["iOS", "MacOS"]
+++
# Members Of Cocoa Concurrency

- Operation Queue

    + abstract base class `NSOperation`

    + concrete subclass `NSInvocation`

    + concrete subclass `NSBlockOperation`

- Dispatch Queue

- Dispatch Source

# Operation Queue Features

1. graph-based dependencies

2. completion block

3. execution status monitoring

4. prioritizeing

5. canceling
