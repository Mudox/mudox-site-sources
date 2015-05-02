+++
author    = "Mudox"
date      = "2015-04-13T18:10:59+08:00"
draft     = true
title     = "SOME UNICODE CONCEPTS CLARIFIED"

tags      = ["Unicode"]
languages = ["ObjC", "Swift"]
platforms = ["iOS", "MacOS", "Win", "Linux", "Web"]
+++

Collect several Unicode concepts encountered when I learn Swift's String type.
<!--more-->

+ UCS

    Universal Coded Character Set (通用字符集)

    > The Universal Coded Character Set (UCS), defined by the International
    > Standard ISO/IEC 10646, Information technology — Universal Coded
    > Character Set (UCS) (plus amendments to that standard), is a standard set
    > of characters upon which many character encodings are based. The UCS
    > contains nearly one hundred thousand abstract characters, each identified
    > by an unambiguous name and an integer number called its code point.

+ Unicode

    统一码，万国码, 单一码

    > Unicode is a computing industry standard for the consistent encoding,
    > representation, and handling of text expressed in most of the world's
    > writing systems. Developed in conjunction with the Universal Character
    > Set standard and published as The Unicode Standard, the latest version of
    > Unicode contains a repertoire of more than 110,000 characters covering
    > 100 scripts and multiple symbol sets.

    As for its' code space layout:

    > Unicode comprises 1,114,112 code points in the range 0x0 to 0x10FFFF.
    > The Unicode code space is divided into 17 planes (the basic multilingual
    > plane, and 16 supplementary planes), each with 65,536 (= 216) code
    > points. Thus the total size of the Unicode code space is 17 × 65,536 =
    > 1,114,112.

+ UTF

    UCS/Unicode Transformation Format (通用字符集转换格式, Unicode 转换格式)

+ UTF-8

    > UTF-8 (U from Universal Character Set + Transformation Format—8-bit[1])
    > is a character encoding capable of encoding all possible characters
    > (called code points) in Unicode. The encoding is variable-length and uses
    > 8-bit code units. It was designed for backward compatibility with ASCII
    > and to avoid the complications of endianness and byte order marks in
    > UTF-16 and UTF-32.

+ code point (code position)

    > In character encoding terminology, a code point or code position is any
    > of the numerical values that make up the code space.

+ Unicode scalar

    > Behind the scenes, Swift’s native String type is built from Unicode
    > scalar values. A Unicode scalar is a unique 21-bit number for a character
    > or modifier.

    The distinction between Unicode scalar & Unicode code point could be
    clarified as follows:

    > A Unicode scalar is any Unicode code point in the range U+0000 to U+D7FF
    > inclusive or U+E000 to U+10FFFF inclusive. Unicode scalars do not include
    > the Unicode surrogate pair code points, which are the code points in the
    > range U+D800 to U+DFFF inclusive.

    It is a Swift language specific notion, or more actually, a Swift defined
    internal type for storing string charactor's Unicode points that Swift
    choose to support. Behind the scene, it's a 21bit long numeric type, but
    not all number in the range can reponds to a valid Unicode point.

    So mathematically, the Unicode points universal set is a discrete subset of
    integer set [0, 0x10FFFF]. The Swift Unicode scalar universal set is, in
    turn, a discrete subset of Unicode code point universal set (with all
    _surroagte pair_ code points stripped).

+ code unit

    > A code unit is a bit sequence used to encode each character of a
    > repertoire. Encodings associate their meaning with either a single code
    > unit value or a sequence of code units as one value.

+ extended grapheme cluster

    > Every instance of Swift’s Character type represents a single extended
    > grapheme cluster. An extended grapheme cluster is a sequence of one or
    > more Unicode scalars that (when combined) produce a single human-readable
    > character.
