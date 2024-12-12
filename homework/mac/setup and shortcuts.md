
(KDE connect) untrusted: `xattr -d com.apple.quarantine kdeconnect-indicator.app`

`cmd + shift + 4/5` for screenshots
`cmd + H` - hide, better than minimize
`cmd + TAB + 🔽`  
> (First press and hold `CMD` key, tap `Tab` key multiple times to switch to the app, then press `Down` arrow key. Navigate using arrow keys, then press return to activate selected window.)
## PIP Fix
no, install poetry using pip install in 3.10 python.
https://github.com/kovidgoyal/kitty/issues/692 - create a new tab from current dir


# brew
```bash
brew install --cask maccy
brew install --cask alt-tab
brew install --cask kitty
brew install fzf
brew install fd ripgrep libpq
brew install java
brew install powerlevel10k
brew install iterm2 
brew install tgpt 
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk \
     /Library/Java/JavaVirtualMachines/openjdk.jdk
```
asfasd

set maccy shortcut to `^ + v`
change alt-tab to show apps from current spaces only `⌥ + tab`

# .zshrc


```sh
#:: Reverse search in tmux workaround in macos
bindkey '^R' history-incremental-search-backward
bindkey '^P' up-history
bindkey -e


# My configs:
# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias python='python3.10'
alias timef='/usr/bin/time -f "Memory used (kB): %M\nUser time (seconds): %U"'
alias less='nvim \+":setlocal buftype=nofile" -'
alias makevenv="python -m venv venv"
alias i="ipython"
alias activate="source venv/bin/activate"
alias rcreload="source ~/.zshrc"
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"
alias kitten="kitty +kitten"
alias d="kitten diff"
alias llm='tgpt -m'
alias ks='kubectl config use-context'

# Quick neovim pointers
alias notes='cd $NOTES && nvim .'
alias obsidian='cd $PREEMPTIVE_IMPRESSIONS && nvim .'
alias tmuxs=~/.local/bin/tmux-sessionizer
alias downloads='cd ~/Downloads && nvim .'

# Git Tricks
alias glgraph='git log --graph --oneline --all --simplify-by-decoration'


# Increase limit - actually, this is not working...
export HISTSIZE=10000
export SAVEHIST=10000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# Shortcuts
export EDITOR=nvim 
export PREEMPTIVE_IMPRESSIONS="$HOME/Documents/preemptive-impressions/"
export NOTES="$HOME/Documents/notes"
export MANPAGER="nvim +Man!"

# Mac specific
export PATH=$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
```
