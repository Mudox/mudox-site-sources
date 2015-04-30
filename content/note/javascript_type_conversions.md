+++
date = "2014-10-28T11:33:15+08:00"
draft = true
title = "JAVASCRIPT TYPE CONVERSIONS"

languages = ["JavaScript"]
platforms = ["Web"]
+++

Here records what I learned about JavaScript's type conversion.
<!--more-->

# Sepcial Value Or Types In JavaScript

## The `undefined`

The `undefined` is the only value of `undefined`, represents unknown value of any
other types, including primitive types & object.

```js
// play with 'undefined'
typeof undefiend                  /* undfeined        */
undefined == undefined            /* true             */
undefined == null                 /* true             */
undefined !== null                /* true             */
Boolean(undefined)                /* false            */
Number(undefined)                 /* NaN              */
```

## The `null`

The `null`, by standards, should be the only value of `null` type, but in certain
browser (e.g. firfox, chrome), it is of type `object`. `null` is used to
represent unknown value of an object.

It is equal to itself and it is equal to `undefined`.

```js
// play with 'null'
typeof null                       /* object           */
null == null                      /* true             */
null == undefined                 /* true             */
null !== undefined                /* true             */
Boolean(null)                     /* false            */
Number(null)                      /* 0                */
```

## The `NaN`

The `NaN` is a `Number` that can not be represented as a number.

It dose __NOT__ equal to itself, hence JavaScript provide a built-in function
`isNaN()` to test if a value is a NaN.

```javascri
// play with 'NaN'
typeof NaN                        /* number           */
NaN == NaN                        /* false            */
NaN == undefined                  /* false            */
NaN == null                       /* false            */
Boolean(NaN)                      /* false            */
Number(NaN)                       /* NaN              */
isNaN(NaN)                        /* true             */
NaN == 0/0                        /* true             */
isNaN(0/0)                        /* true             */
```

# Implicit Type Conversions

## When other types need to be converted into a number

When different types are mixed in a relational operation (i.e `== != < <= >
>=`) except the `===` operator, or an arithmetic operation, except
the `+` operator, they would be converted into numbers first.

### For Boolean:

* true would be converted to 1

* false would be converted to 0

### For String:

It is converted literally, i.e.

```js
'2014' < 2 /* 2014 < 2 yields false */
'3.1415' == 3.1415 /* 3.1415 == 3.1415 yields true */
```

There is one exception: a `emtpy` string would be converted to 0.

```js
var emptyText = '';

/* 'emptyText' here, converetd to 0, is compared to true which is converted to 1,
and then '!' negates the results to true */
if (!emptyText) {
  console.log('empty text is not true!')
}
```

## When other types need to be converted into a string

### The special `+` operator

In JavaScript, the `+` is first a string concatenation operator, then a
arithmetic addition operator.

When one of `+`'s operands is a string, JavaScript will try to convert the
other operand into a string, and perform a concatenation operation.

### For Boolean:

* `true` would be conveted bo "true"

* `false` would be conveted to "false"

### For `null`, `undefined` & `NaN`

they all be converted literally.

## When other types need to be converted into a boolean value

from 《Head First JavaScript Programming》:

> the secret to learning what is truthy and what is falsey is to learn what’s
> falsey, and then consider everything else truthy.
> concentrate on  knowing what is falsey, and then everything else you can
> consider truthy.

it is a golden rule that also applys in many other programming language
learning situations.

As to what value should be considered as falsey, different language has
different policy. There are __5__ falsey value in JavaScript:

1. `undefined`

2. `null`

3. `NaN`

4. `""`

5. `0`
