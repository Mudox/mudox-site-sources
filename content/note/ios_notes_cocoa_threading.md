+++
author    = "Mudox"
date      = "2014-09-24T21:19:59+08:00"
draft     = true
title     = "iOS NOTES - COCOA THREADING"

tags      = ["Cocoa", "Concurrency"]
languages = ["ObjC", "Swift", "C"]
platforms = ["iOS", "MacOS"]
+++

# Run Loop

## 4 roles participate in the run loop game:

1. __Run Loop__

    which is represented by `NSRun Loop` & `CFRunLoop`.

2. __Run Loop Mode__

    which is represented by `CFStringRef` associated to each instance of run
    loop object.

3. __Run Loop Source__

    which is represented by `CFRunloopSource`.

    - Input source

        + Port-based source

        + Perform selctor on other threads

        + Custom source

    - Timer

        which is represented by `CFRunloopTimerRef`.

        + Explictly defined timer

        + Perform selector on current thread with delay

        + Perform selector

4. __Run Loop Observer__

## 4 ways to kill a run loop iteration:

1. no sources exists

     since some system routines may install certain input sources to the run
     loop implictly, we should not kill a run loop iteration by clearing '_all_'
     sources we known.

2. timeout

3. sourced handled in one-shot mode

4. explicitly stoped by `CRunloopStop`


## 3 kinds of perform selector sources.

on thread     |invocation|delay|blocking call?     |mode
---           |---       |---  |---                |---
current thread|√         |√    |always non-blocking|√
other thread  |√         |x    |√                  |x
main thread   |√         |x    |√                  |x

# Alternatives To Threaing

1. Operation Objects

2. Grand Central Dispatch (GCD)

3. Idle-time notifications

4. Asynchronous functions

5. Timers

6. Separate processes

# Cocoa Support For Threading

1. Cocoa threads

2. POSIX threads

3. ~~Mutiprocessing Services~~ (_obsolete_)

# Inter-Thread Communication

1. Direct messageing

2. Global variables, shared memory & objects

3. Conditions

4. Run loop sources

5. Ports & sockets

6. ~~Message queues~~ (_obsolete_)

7. Cocoa distributed objects

# Synchronization Tools

1. Atomic operation

    - atomic add

    - atomic increment

    - atomic decrement

    - compare-and-swap

    - test-and-set

    - test-and-clear

2. Memory barriers

3. Volatile variables

4. Locks

    - Mutex

        + POSIX API provides `pthread_lock_t`

        + Cocoa provides `NSLock` &  `@synchronized()`

    - Recursive lock

        which is provided as class `NSRecursiveLock`

    - Read-write lock (_pthread only_)

    - Distributed lock

    - Spin lock (_not implemented_)

    - Double-checked lock

5. Conditions (aka _condition variable_)

6. Perform selector routines
