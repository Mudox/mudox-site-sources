+++
date = "2014-11-07T09:24:33+08:00"
draft = true
title = "ERROR COLLECTION - BASH"

tags      = ["Shell"]
platforms = ["Linux", "MacOS", "Win"]
languages = ["Bash"]
series    = ["Error"]
+++

Errors that I collected day by day, when writing the Bash scripting language.
<!--more-->

* Body of `select` constructs need a `break;` to quit the selection loop.

```bash
select answer in #choices#; do
  #body#
  break; # <- go out of selection loop.
done
```

* Always `source` before testing a updated command.

* Whence quoted with `"`, which is the most case, use the `@` form (i.e.
  `"${ARRAY[@]}"`) to expand a array correctly. The `*` form will make the
  expanded string as a **single word**.

* The `local path` is the source of all evil. It will shaddow the global `path`
  where binary search paths is hold in zsh.

* No need to `"` quote variable that expand to a number in `$(( ))`, which need
  a real number.

```bash
index=$(( RANDOM % "${#array[@]}" )) # no need to double quote '${array[@]}' here
```
