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
```
fetch - do manual rebase
pull - auto merging
## Tags
`feat(scope): message` feat is a tag here.
check: https://www.conventionalcommits.org/en/v1.0.0/
or, annotate a commit using `git tag -a v2.3 -m "tagging"`
## Checkpoint
https://git-scm.com/book/en/v2/Git-Basics-Tagging 

---
# Branching

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
