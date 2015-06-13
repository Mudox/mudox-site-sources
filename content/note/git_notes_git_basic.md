+++
date      = "2014-10-02T03:36:12+08:00"
draft     = true
title     = "GIT MISC"

tags      = ["Git", "Tool"]
languages = ["Bash"]
platforms = ["MacOS", "Win", "Linux"]
+++
# Alias

- working tree, working directory

- index, staging area, cache, staged snapshot

- commit[ted] history, commit[ted] snapshot

# The `add` & `rm` & `reset` & `commit` & `checkout` Sub-commands.

- between the _committed history_ & _staging area_

    * `commit` submit changes from _staging area_ to _committed history_

    * `reset` revert changes from _committed history_ back to _staging area_

- between the _staging area_ & _working tree_.

    * `add` submit changes from _working tree_ to _staging area_, preparing
for committing.

    * `rm` remove file(s) from _stageing area_, so they become _untracked_.

- `checkout` restore changes from staging area or a specific commit of committed
history to _working directory_.

- `reset`

    * __unstages__ changes in staging area.
v
            git reset <paths>

    * or, if you ask for more, __uncommits__ changes in history.

            git reset <commit-ish>

- `rm`

    * __untracks__ file(s) previously tracked in staging area.

            git rm --cache <paths>

    * or, if you ask for more, __removes__ file(s) in the work directory.

            git rm <paths>

- `git reset` vs `git checkout`

    * `git reset <commit-ish> <paths>` only update _staging area_.

    * `git checkout <paths>` fetch `<paths>` from _staging area_ to working
direcotry.

    * `git checkout <commit-ish>` fetch `<paths>` from _history_ to both
_index_ & _working direcotry_.

# The `git Rebase` Sub-command

## Advantage of `rebase`:

- no additional merge commit

- linear commit history

## Disadvantage of `rebase`:

- safety

- tracability: the evidences of merging are wiped away.

## Golden rule of `git rebase`:

__never__ use it on __public__ branches.

## When to use `rebase`

- Local cleanup

- Incorporating upstream changes into a feature branch

- Integrating a approved feature

# The `reset`, `checkout` And `revert` Sub-commands

> The parameters that you pass to `git reset` and `git checkout` determine
> their scope. When you don’t include a __\<file path\>__ as a parameter, they
> operate on whole commits.  Note that git revert has no file-level counterpart

from [atlassian's git tutorials][tutor]

## Commit level operations

`git reset --[soft | mixed | hard] <commit-ish>` __move__ branch tips backwards
or even forwards, while affecting _staging area_ & _working direcotry_ according to
options it is given.

option   |history|staging area|working directory
-------  |-------|------------|-----------------
`--soft` |√      |            |
`--mixed`|√      |√           |
`--hard` |√      |√           |√

`git checkout <commit-ish>` dose not move tips around.

`git revert` undo commits by adding a new commit. it is a safe (reversible) way
to undo commits, while `git reset` is dangerous (irreversible) way to undo
commits.

## File level operations

    git [reset|checkout] <commit-ish> <pathspec>

command                                |history|staging area|working directory
---------------------------------------|-------|------------|-----------------
`reset`                                |       |√           |√
`checkout`                             |       |            |√

# Summary

command   |commit level                                                        |file level
--------  |--------------------------------------------------------------------|-----------
`reset`   |discard commits in private branches or throw away uncommited changes|unstage a file
`checkout`|swtich between branches or inspect old snapshots                    |discard changes in the working directory
`revert`  |undo commits in public branches                                     |__N/A__

[tutor]: https://www.atlassian.com/git/tutorials/resetting-checking-out-and-reverting/commit-level-operations
