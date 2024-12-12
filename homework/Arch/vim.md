fn + f12 for yakuke terminal  
netrc - ctrl + o  
d for dir  
% for file  
/home/guts/.config/nvim  
== re-adjust tabs to spaces  
nvim .  
  
after / plugin - is automatically sourced  
lua/ - is ready to be acquired  
  
netrw  
- R rename  
- r reverse  
- s sort-by  
  
init - updates the files, make sure everything is ready,  
after - once the above thing is done, now configure stuffs  
  
X fix color scheme - transparent - tokyo night  
  
sourcing manual:  
```
:so %  
:PackerSync  
:VimBeGood  
```
ctrl - o & ctrl - I  
previous location & next location  
[https://vim.fandom.com/wiki/Jumping_to_previously_visited_locations](https://vim.fandom.com/wiki/Jumping_to_previously_visited_locations)  
:jumps  
:vsp filename (vertical split)  
  
ctrl ww - jump  
  
yank highlighted region  
highlight another line, and Paste  
**** if you paste again... the stuffs that got replaced by Pasting previously appears again, because, delete and yank uses same buffer ****  
  
**COMMAND - COUNT - MOTION**  
eg: d 10 j > removes 10 lines  

---
## Lesson 2  
  
`_` move to the beginning of the sentance  
0 move to the literal beginning of the sentance  
`$` to end of line  
  
`f<char>` moves to first occurance of char in the line  
`t<char>` moves just before the first occurance  
  
`F <char>` performs the same, but in search in reverse direction  
`T <char>`  
  
`;` repeat forward `f/t <char> ` 
`,` repeat backward  
  
`I` insert mode at the beginning of the line  
`A` at the end of the line  
  
`o` - make a newline and Insert mode  
`O` - make a newline above the cursor and Insert mode  
`Selects = `align automatically  
`=ap` 8 space indenting  
  
---
  
`ctrl + d` = skip like 25 lines at a time bottom  
`ctrl + u` = "" "" up  
  
---
  
`V` - Visual Line  
`K,J` - move highlighted text  
  
`n, N` - Next term on search  
`_p` - better than normal paste  
`_y` - yank into system clipboard (+ register)  
`y` - is just within vim  
`_s` : replace all  
## Advanced:  
[visual actions](https://vimdoc.sourceforge.net/htmldoc/visual.html#CTRL-V)
`vi{ | vi[ | vi( `- select contents between paranthesis  
`va` - including the brackets  
`ya( yi{` - just yank  
`yap` - full paragraph (bw space)  
`da di`  
`ca ci"` - cuts & insert mode  
`sa si`  
  
`viw/W` - select a word / until spaces  
`o in V` jumps b/w end  
  
`>4j` intend  
`yap / dap / yip / dip` - a to nuke white space, `i` to preserve it  
  
`Ctrl+a` increment  
`Ctrl+x` decrement  
([https://learnbyexample.github.io/tips/vim-tip-1/](https://learnbyexample.github.io/tips/vim-tip-1/))  
`ctrl+v` multiple cursor `->` `I` insert (type) and press escape  

Replace All:
- Highlight with `v`  
- press `':'  `
- `s/\(\w.*\) ` 
  
`select - g + ctrl + a` increment all  
`%` - jump between brackets  
  
`gd` - jump to definition  
`ctrl w o` (close all window)  

---
`{` - paragraph jump  
`G` - to bottom  
`gg` - to top  
`:100` (exact jump)  
`/fun` - search -` n / N ` 
`?fun  `
`*` highlighted word search  
`/word1\|word2\|word3` multiple search highlights
  
check from [12:44 ](https://www.youtube.com/watch?v=FrMRyXtiJkc&list=PLm323Lc7iSW_wuxqmKx_xxNtJC_hJbQ7R&index=7)
[also check](https://www.youtube.com/watch?v=FrMRyXtiJkc&list=PLm323Lc7iSW_wuxqmKx_xxNtJC_hJbQ7R&index=7)  
  
`Ctrl w o` close all window  
`Ctrl w` = equal size of all windows  
`gh` select the right side changes on diff view  - **need more guide**  

`Shift + K` => get function description  
`:g/func/#` - list out all fuctions in a file  
`:v/pattern/d` - inverse regex matches, and delete the lines
`:dlist /` - list file specific definitions from root - check these in your free time `:help definition-search, :help 'include', :help 'define', :help 'suffixesadd'`
`:vimgrep something %`
`:copen` - quickfix list with results populated from above command
`:cn`, `:cp` - next / prev item in a quickfix list (better than `<Ctrl ww>` and switching back and forth)
`:ccl` - close quickfix list
https://stackoverflow.com/questions/13306664/pipe-search-result-to-other-tab-window-buffer-in-vim 
[https://vi.stackexchange.com/questions/5941/summary-of-functions-in-current-file](https://vi.stackexchange.com/questions/5941/summary-of-functions-in-current-file)  

**redirect search results to a new buffer**
```sh
:redir @a
:g/for.*bar/#
:redir END
:enew
:put! a
```
[**Redir even better**](https://www.reddit.com/r/neovim/comments/1dyweok/redirnvim_redirect_command_output_to_neovim_split/) 

## Resize window
- Ctrl+W +/-: increase/decrease height (ex. `20<C-w>+`)
- Ctrl+W >/<: increase/decrease width (ex. `30<C-w><`)
- Ctrl+W _: set height (ex. `50<C-w>_`)
- Ctrl+W |: set width (ex. `50<C-w>|`)
- Ctrl+W =: equalize width and height of all windows

See also: `:help CTRL-W`
## netrw shortcuts  
`gh`: hide git files  
  
Check: <https://stackoverflow.com/questions/67898068/neovim-is-transparent-but-the-auto-copplete-window-is-pink-how-to-make-it-semi-t>
<https://stackoverflow.com/questions/67898068/neovim-is-transparent-but-the-auto-copplete-window-is-pink-how-to-make-it-semi-t>

---
`set foldmethod=indent` - for python folding
`:5,16fo`
`select lines + fo`: fold lines
^ this is range in commands
`za` toggle between fold
`zr` unfold all
`zE` delete all folds
`Ctrl w v` - vertical split window or `:vs`
`:on` closes all other windows
`Ctrl w r` - rotate windows 

## macros
`qa` - it saves your movements on buffer 'a'. stop macro recording by pressing 'q'
to, replay the macro, in normal mode: `@a`
`500@a` 
`:g/pattern/normal @q` run a macro on all matches _(have to test)_
[decent fcc vim guide](https://www.freecodecamp.org/news/learn-linux-vim-basic-features-19134461ab85/#9b6b)
**Bulk Cut Paste matching pattern**
`/KC_\w*`: pattern 
`qh`: record movements at buffer '@h'
`ndiw<Ctrl>wwp<Ctrl>ww`: perform this movement to paste the cut word in another window
`100@h` - repeat until everything is done
`:sort u` - keep only unique values
`:'<,'>s/\\//g ` - string json -> json. (don't forget to remove the surrounding `"` quotes tho)


```c
int encrypt_text(char *text, int bytes);
int decrypt_text(char *text, int bytes);
int process_text(char *text, int bytes);
int another_important_function(int bytes, double precision);
```

---
## Fugitive
https://t.me/ERsiowj12h6s7w282jwheyueyywkwlwj/5496
https://dzx.fr/blog/introduction-to-vim-fugitive/#introduction
[vim casts](http://vimcasts.org/episodes/fugitive-vim-working-with-the-git-index/)

`do dp` diffget and diffput for selecting hunk. works on range too
`:G log -- %` commits made on current file
`:G diff-tree --no-commit-id --name-only -r <commit_id>` list of changed files of a commit
`:G diff --name-only temp/VP-686-query-profiling VP-686-query-profiling` - list of changed files between two branches

## SSH Filesystem 
while surviving network failures, edit any directory / files in your nvim editor!!
```bash
sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 user@192.168.18.3:/home/user/binlog-test ~/sshfiles

nvim sshfiles

# unmount directory
fusermount -u ~/sshfiles
```
> [!tip]+ File ownership
> The last edit username of the files will be the same as your local machine. If needed use `idmap`, `uidfile`, and `gidfile` to map user / group IDs correctly

`100i0<enter><esc>vggg<ctrl-a>` dope.  `g<ctrl-a>` modifies the increment behaviour
**[The Power of :g](https://vim.fandom.com/wiki/Power_of_g)**

## Other Cool Things
[link](https://www.reddit.com/r/neovim/comments/11ias6e/whats_the_coolest_thing_youve_done_with_neovim/) 
- `.nvim-commands.lua` - to have keybindings with Toggleterm (F1 to build), (F2 to run), (F3 to run the test under the cursor 🤫). Saves the overhead of switching terminal and typing each time.   [the repo](https://github.com/SerenityOS/tree-sitter-jakt/blob/main/.nvim-commands.lua)
```lua
-- Load toggle term
["t"] = { "<cmd>ToggleTerm<CR>", "toggle toggleterm" },
["T"] = { "<cmd>ToggleTerm direction=tab<CR>", "toggle toggleterm (tab)" },
-- Load nvim-commands file
["n"] = { "<cmd>luafile .nvim-commands.lua<CR>", "load nvim-commands.lua" },
```
- Copy the huge string literal (longest was several paragraphs of Lorem Ipsum), and use a macro to get each word on its own line. Then I filtered it through `sort`, then `uniq -c`, then a `:s` with some backreferences and boom I had _so many_ lines of `theMap.insert` or whatever the method is called for a Java hashmap.
- [telescope media!](https://github.com/dharmx/telescope-media.nvim) 
- compress multiple blank lines into single `:v/./,/./-j`

## Give It A Read
- https://neovim.io/doc/user/lsp.html
- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/lsp.md#introduction

## Playlist Making
```r
%s/C:/\/run\/media\/guts\/Acer/gI %s/\\/\//gI
```
unpack uri provider: https://claude.ai/chat/71ec0667-1432-4247-bc7e-0700426bdc00

## Run script and output to window
https://superuser.com/questions/868920/open-the-output-of-a-shell-command-in-a-split-pane

`:vnew | 0read ! <command>` 

# LSP
`:LspInfo` - get info
`LspStop 2` - give ID to detach a lsp from the buffer [ref](https://www.reddit.com/r/neovim/comments/pnl2zs/comment/hcq3of3/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button) 

# Friendly Snippets
https://github.com/rafamadriz/friendly-snippets/tree/main
`Ctrl + f`: select the next highlight in snippet
`Ctrl + b`: select the prev highlight in thte snippet 

## neovim diff
[sause](https://oozou.com/til/use-neovim-as-a-git-difftool-57) 
[Docs](https://neovim.io/doc/user/diff.html)
`:vert diffsplit folder/file` - vertical diff between files 
```sh
nvim -d file1 file2
:diffthis 
:diffoff # turns off diff in current window
:diffs file.yaml
:diffs -o file
:vert diffsplit file.yaml
:G diff a/file.yaml b/file.yaml
:G difftool a/file.yaml b/file.yaml
:h :diffsplit
:G diff @
:windo diffo
:windo difft
```
## Mason, lsp-zero, null-ls relation
https://www.reddit.com/r/neovim/comments/13xyixb/some_questions_about_code_formatting_with_lspzero/

## Replace \n with actual new line 
`set magic`
`:s/,/,^M/g`
You get ^M character by presssing ctrl+v and then enter
[ref](https://stackoverflow.com/questions/71323/how-to-replace-a-character-by-a-newline-in-vim) 
