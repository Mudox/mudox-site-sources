+++
date = "2014-10-26T21:36:29+08:00"
draft = true
title = "WEB PAGE LAYOUTS"

languages = ["CSS", "HTML"]
platforms = ["Web"]
+++

# Liquid Layout

This is the browser's default layout behavior, if you did not add any CSS to
style a page. The block elements, like liquid, just fill as much space as they
can in the pages.

# Frozen Layout

By using the CSS attribute combination of `float` and `width`, we can put a
__containing__ block (i.e. `<seciton>`, `<aside>`, `<div>`) to float on to
left-most or right-most side forming a __column__, and let the  remaining
content to flow around the fixed-width floating column, forming the other
column.

Use CSS attribute `clear: [left | right]` to let a block to layout fully
underneath a floating elements.

# Jello Layout

On the basis of frozen layout, we can use containing fixed-width block to wrap
all columns (floating or flowing), and by using `margin-left: auto;
margin-right: auto;` CSS style, to center the contained columns in the page.

# Absolute Position

By using the CSS attribute combination of `position: [absolute | fixed]` and
`left | right | top | bottom: ...`, we can take the column fully out of layout
flow, and fix their position relative to the page (`position: absolute`), or to
the viewport (`position: fixed`).

# Table Display

Use CSS attribute `display: [table | table-row | table-cell]` to organize HTML
elements into an invisible table.

Most of the time, `vertical-align: top` will help you to get what you want to see.
