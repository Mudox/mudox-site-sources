+++
date      = "2014-09-28T16:38:26+08:00"
draft     = true
title     = "GIT FLOW"

tags      = ["Git", "Tool"]
languages = ["Bash"]
platforms = ["MacOS", "Win", "Linux"]
+++
# 1. Main Branches

- the `main` branch

    keeps the official release history (usually with version nubmer tags
    attached).

    i.e. every commits in master is a new release. all branches merged back
    into master must have a new incremental version number.

- the `develop` branch

    serves as an integration branch for features.

    nitghly build built from it.

# 2. Supporting Branches

## 2.1 feature (or topic) branches

branch off from: `develop` branch

merge into: `develop` branch

naming convention: any name except `master`, `develop`, `relase[/-]*`,
`hotfix[/-]*`

```bash
# Branch A New Feature Branch Off From Develop Branch
git checkout -b some-feature develop
# Add Feature Commits To Branch Some-feature ...
# Merge Feature Branch Back Into Develop Branch.
git checkout develop
git merge --no-ff some-feature
git push origin develop
```

## 2.2 release branches

branch off from: `develop` branch

merge into: `develop` & `master` branch

naming convention: `release/*` or `release-*`

```bash
# Branch A New Release Branch Off From Develop Branch
git checkout -b release-<version number> develop
# Bummp Up Version In Related Fiels.
git commit -m 'Bumped version number to <version number>'
# Roll Out Release, Minor Bug Fixes
# Merge The Release Into Master, And Give It A New Tag.
git checkout master
git merge --no-ff release-<version number>
git tag -a <version number>
# Merge The Release Back Into Develop
git checkout develop
git merge --no-ff release-<version number>
```

## 2.3 hotfix (or maintenance) branches

branch off from: `master` branch
merge into: `develop` & `master` branch if no active release branch existed
currrently.
naming convention: `hotfix/*` or `hotfix-*`

```bash
# Branch A New Hotfix Branch Off From Master Branch
git checkout -b hotfix-<version number> master
# Bummp Up Version In Related Fiels, Becuase It Will Finnaly Be Merged Back
# Into Master Branch.
git commit -m 'Bumped version number to <version number>'
# Roll Out Hotfix, Minor Bug Fixes
# Merge The Hotfix Into Master, And Give It A New Tag.
git checkout master
git merge --no-ff hotfix-<version number>
git tag -a <version number>
# Merge The Hotfix Back Into Develop
git checkout develop
git merge --no-ff hotfix-<version number>
```
