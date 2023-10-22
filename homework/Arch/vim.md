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
  
check from [12:44 ](https://www.youtube.com/watch?v=FrMRyXtiJkc&list=PLm323Lc7iSW_wuxqmKx_xxNtJC_hJbQ7R&index=7)
[also check](https://www.youtube.com/watch?v=FrMRyXtiJkc&list=PLm323Lc7iSW_wuxqmKx_xxNtJC_hJbQ7R&index=7)  
  
`Ctrl w o` close all window  
`Ctrl w` = equal size of all windows  
`gh` select the right side changes on diff view  - **need more guide**  

`Shift + K` => get function description  
`:g/func/#` - list out all fuctions in a file  
[https://vi.stackexchange.com/questions/5941/summary-of-functions-in-current-file](https://vi.stackexchange.com/questions/5941/summary-of-functions-in-current-file)  
  
---
## netrw shortcuts  
`gh`: hide git files  
  
Check: <https://stackoverflow.com/questions/67898068/neovim-is-transparent-but-the-auto-copplete-window-is-pink-how-to-make-it-semi-t>
<https://stackoverflow.com/questions/67898068/neovim-is-transparent-but-the-auto-copplete-window-is-pink-how-to-make-it-semi-t>