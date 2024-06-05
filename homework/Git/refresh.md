add: "include this for next commit"
MM - Staged and yet modified again

```bash
git add <file>
git status -s
git diff --staged #(same as cached)
git commit -a #(automatically adds previously tracked file for commit)
git rm log/\*.log #removes from tracking further (file is still in machine) (glob pattern)
git log -S func_name #(find the last commit that added or removed a reference to a specific function)
```

## .gitignore
standard regex `[ ]`, `?`, `*`, `-` (range)
Standard glob pattern ?
start with / - avoids resursivity 
end with / - indicates it's a directory
! negate a pattern
`a/**/z` match all nested directories

```
# ignore all .a files
*.a

# but do track lib.a, even though you're ignoring .a files above
!lib.a

# only ignore the TODO file in the current directory, not subdir/TODO
/TODO

# ignore all files in any directory named build
build/

# ignore doc/notes.txt, but not doc/server/arch.txt
doc/*.txt

# ignore all .pdf files in the doc/ directory and any of its subdirectories
doc/**/*.pdf
```
It's possible to have .gitignore files inside other directories

## Danger Zone
If done carelessly, your work might get lost
### amend - undo / edit commit
```bash
git commit --amend
```
### Checkout a file 💀 - stashing / branching is better
```bash
git checkout -- file_name.ext
```
### restore
```bash
git restore --staged file_name
```
---
## Remotes
```bash
git remote -v
git remote show origin
git remote add ci-team git@github.com:User/UserRepo.git

git ls-remote <remote> # (list all reference to remote)
```
fetch - do manual rebase
pull - auto merging

in Fork based devolopment, the forked copy you have is the **'origin'**
the original repository is the **'upstream'**
so, you'll have these two as the remote
## Tags
It's another way to point to a snapshot (commit). 
But it's not a branch. You're not supposed to use it to checkout and make changes from a commit that is linked with a tag.

For me atleast, it feels like, this is used as a workaround way to implement '**Releases**' from github side. ie, that's why it felt pointless to do in Git cli.
![[Pasted image 20231028171542.png]]
using semantic versioning with tags is highly recommended unlike the above screenshot
annotate a commit using `git tag -a v2.3 -m "tagging"`

---
# Branching - working silos

A pointer that moves to any stored ***snapshots*** (commits of blobs).
![[Pasted image 20231027224231.png]]
```bash
# To display commits that are ahead of head pointer
git log --all
git log --oneline --decorate --graph --all

# Create branch
git branch settings-page
# Instead of old checkout: try
git switch -c settings-page #-c is create
git switch settings-page
git switch - # switch to previously checkout branch
```

---

# Merging

## Scenario
You're working in your web project's new **story** feature. And suddenly, you're assigned on to fix a issue. You do that, and push it to **production**. 
And, you're again back at branch story.
```git
         *  <- issue #69 hotfix branch
	   /  \
* * * *    *   <- production
	   \
	    *  *  <- your story branch
```

1. Checkout to the branch you want to merge - `main`
2. run `git merge hotfix`. git fast-forwards (just moves the pointer if the commit was continous & linear). Face divergent work / merge conflicts otherwise

```bash
git branch -d hotfix
git mergetool
```

> [!tip]- Just use github desktop
> coz, when all your files are littered with `>>>>>>>>>>>>>>>> upstream` & `<<<<<<<<<<<<<<<< staged` changes, you'll have hell of time to manually sort it out. 
> 
> Additionally, there's no proper 'understandable' guide on how to properly 'navigate' in vim between fugitive diff screen

## Branch Management
Ahh, I've totally forgotten that you can branch form a branch... ehhh...
![[Pasted image 20231028182733.png]]
```bash
git branch --move old new   # (rename branch locally)
git push --set-upstream new # (yea, headache. so never rename branch)
git push origin --delete old

git branch -d new           # (delete)
git branch --all            # (name all including origin ones)

# list merged and not merged branches in relative to main branch
# if unspecified, it compares with current branch
git branch --merged main
git branch --no-merged main
```

Waiting for rebase topic to come...
![[Pasted image 20231028183137.png]]

## Remote Branches
Fetch only brings down remote tracking branches. They are not available to edit, not available to be checkedout. Can't modify those branches.
**you're supposed to merge them manually!**
```bash
git clone -o fufufufu # (instead of origin)
git fetch team-ci/master

# Share to the world
git push team-ci server-fix
git push origin serverfix:best-server-fix # (push in different name to origin)

# Create a branch and merge origin changes after a fetch
# look for the 'track remote' in STDOUT. if not go link manually a upstrem branch
git checkout -b serverfix origin/serverfix # (editable copy of origin/serverfix)
```
### Change upstream of a branch
```console
$ git branch -u origin/serverfix
Branch serverfix set up to track remote branch serverfix from origin.
```
### Branch status in coherent to origin
```bash
git fetch --all
git branch -vv # (a detailed report on current branch)
```
```console
$ git branch -vv
  iss53     7e424c3 [origin/iss53: ahead 2] Add forgotten brackets
  master    1ae2a45 [origin/master] Deploy index fix
* serverfix f8674d9 [teamone/server-fix-good: ahead 3, behind 1] This should do
  testing   5ea463a Try something new
```
> **`... ahead 3, behind 1`**
> it means local has 3 unpushed commits. and, 1 unmerged commit from the origin
> **these stats may change after a fetch when new changes happen in repository**

---

# Rebase
Reapplying changes over other commit. you can take all the changes that were committed on one branch and replay them on a different branch.

```bash
git rebase main experiment
# or       ^ base   ^topic branch
git switch experiment
git rebase main

# then do the ffmerge
git switch main
git merge experiment
```

> If you examine the log of a rebased branch, it looks like a linear history: it appears that all the work happened in series, even when it originally happened in parallel.

```bash
# multiple branch rebasing
git rebase --onto main server client

# then do the ffmerge
git switch main
git merge client
```

## When to not Rebase

> **Do not rebase commits that exist outside your repository and that people may have based work on**.
> If you follow that guideline, you’ll be fine. If you don’t, people will hate you, and you’ll be scorned by friends and family

Suppose you have a public repository on GitHub with a few commits. You clone the repository to your local machine and start working on a new feature. You make a few **commits to your local** branch, but you **haven't pushed** them to the remote repository yet.

In the meantime, someone else clones your repository ~~and merges your commits into their own branch~~. They then make some changes of their own and **push their changes** to the remote repository.

Now, **if you rebase your local branch, you will overwrite the commits that have already been pushed to the remote repository**. This will cause problems for the other person, because their changes will no longer be compatible with the history of the repository.

- This is because rebasing can overwrite commits that have already been pushed to the remote repository. This can cause problems for other people who are working on the same project, as their changes may no longer be compatible with the history of the repository.

- If you push commits somewhere and others pull them down and base work on them, and then you rewrite those commits with `git rebase` and push them up again, your collaborators will have to re-merge their work and things will get messy when you try to pull their work back into yours.

![[Pasted image 20231101235525.png]]
the history of merge (last week) + the history of rebase (this week after `--force push`)
both is present in another dev's local copy. if he pushes this, the history looks cluttered 
*(redundant commits that are essentially the same thing)*

## Rebase on top of force-pushed rebase work
```bash
git pull --rebase
# or
git fetch
git rebase main
```

> **Fine:** 
> If you only ever rebase commits that have never left your own computer, you’ll be just fine
> If you rebase commits that have been pushed, but that no one else has based commits from, you’ll also be fine
> 
> **Not Fine:**
> If you rebase commits that have already been pushed publicly, and people may have based work on those commits, then you may be in for some frustrating trouble, and the scorn of your teammates.

> [!tip] Merge & Rebase
> You can get the best of both worlds: rebase local changes before pushing to clean up your work, but never rebase anything that you’ve pushed somewhere

---
# Checkpoint 
Next: Protocols https://git-scm.com/book/en/v2/Git-on-the-Server-The-Protocols (I want to do sec 5 distributed git tho)
Reversing commit: https://git-scm.com/book/en/v2/Git-Tools-Advanced-Merging#_advanced_merging

# Niwyas approch to fetch a branch
```bash
git remote -v
git fetch origin naiss-dev
git checkout origin/naiss-dev
git switch -c naiss-dev
```

## git diff:

[further ref](https://www.atlassian.com/git/tutorials/saving-changes/git-diff_)
```bash
git diff branch1 branch2 -- path/to/file
git diff <commit_hash1> <commit_hash2>
git diff branchA...branchB

# exclude additions and deletion from hightlights
git diff --diff-filter=MRC
git diff --find-copies-harder -B -C
```

[Git Butler Oldies but Goodies](https://blog.gitbutler.com/git-tips-1-theres-a-git-config-for-that/)
## Proper way to use tokens
`gh auth login` command,
![](https://github.com/cli/cli/issues/286#issuecomment-988229488)
