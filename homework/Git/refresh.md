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

For me atleast, it feels like, this is a work around way to implement '**Releases**' from github side. ie, instead of modifying exisisting 'commit' implementations and blah blah. 
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

# Checkpoint 
Next: Rebasing https://git-scm.com/book/en/v2/Git-Branching-Rebasing
