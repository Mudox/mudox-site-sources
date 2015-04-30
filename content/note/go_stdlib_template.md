+++
date      = "2014-09-26T14:52:32+08:00"
draft     = true
title     = "GO'S TEMPLATE LIBRARY"

tags      = ["Libraries"]
languages = ["Go"]
platforms = ["MacOS", "Win", "Linux"]
+++

I come across this library when I started to use [Hugo](http://gohugo.io),
which says:

> It is an extremely __lightweight__ engine that provides a very small amount of
> logic. In our experience it is __just the right amount of logic__ to be able to
> create a good static website.

<!--more-->

# 3 Steps Using The Template Object ##

1. `New` an template object.

2. `Parse` template text.

3. `Execute` (apply) the template to data structure.

# 6 Action Families ##

__comment__

```go
{{/* comment here, line spanning allowed */}}
```

__pipeline__ like variable expansion (substitution)

```go
{{pipeline}}
```

__if__ family for branching logic

```go
{{if _pipline_}} T1 {{end}}
{{if _pipline_}} T1 {{else}} T0 {{end}}
{{if _pipline_}} T1 {{else if _pipeline_ }} T0 {{end}}

```

__range__ family for iteration (loop)

```go
{{range pipepine}} T1 {{end}}
{{range pipepine}} T1 {{else}} T0 {{end}}

```

__with__ family for cursor (dot) moving

```go
{{with pipeline}} T1 {{end}}
{{with pipeline}} T1 {{else}} T0 {{end}}

```

__template__ family for tempates invocation
```go
// with the dot '.' set to nil.
{{tempalte "name"}}
// with the dot '.' set to value of 'pipeline'.
{{tempalte "name" pipeline}}

```


# Argument Types

+ untyped __constants__ in go syntax

+ __nil__ -- the special constant

+ __variable__ name

    `$variable_name` or `$`

+ `.` -- the so called 'context' constant

+ dot chain consist of: __field__ name,  __key__ name,  niladic __method__ name

```go
(.Field.Key.Method args...).Field.Key ...
```

+ niladic __function__ name

+ parenthesized __group__ of above

```go
print (func arg...) (.method arg...)
```
