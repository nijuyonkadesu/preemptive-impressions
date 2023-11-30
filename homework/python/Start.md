```python
r'raw text \t' #doens't converted into tab

return f'Donuts: {count if count < 10 else "many"}'
return sorted(words, key = lambda word: if word[0] != 'x', word)
# the sorted fn now compares (False, word), and false is arranged first

del var # nukes from memory
```
## Files
Reading from file stream gives a string, not a list. so iterating it you'll get character.

> apply things like `isalpha()` and other character level function to further clean the input before passing it to another stage. Like if you're splitting to word. so think before using `.split()` just like that

```python
with open('foo.txt', 'rt', encoding='utf-8') as f:
	for line in f:

```

## [Regex](https://regex101.com/)
In match, everything *stops* when first match is found.
```python
import re
unfilteredSource = """ fineall    okman*&
xyz alice-b@google.com purple monkey """

firstMatch = re.search(r'\b\w+', unfilteredSource, re.IGNORECASE)
firstMatch.group()

matches = re.findall(r'\b\w+', unfilteredSource) # A list of all matches
# if pattern contains () () grouping, then the result is list of **tuples**

re.sub(match_pattern, replacement_pattern, source_string)
```
> [!tip ]+ Anamoly
> `.*` doesn't match newline
> `\s` matches newline
> `^$` match the start and end of the entire string

![[Pasted image 20231115205006.png]]
```regex
.  match any character except newline
\w match word character [a-zA-Z0-9_]. it only matches single character!
\W match non-word character
\s match white space [ \n\r\t\f]
\S match non-white space
\d match digit
^  start
$  end
\  escape sequence to match chars that have special meaning [\. \\ \@ \$ \^]
\b boundary - marks the start and end of the word
	eg: r'\b\w+' grabs all the word of a sentance

[a-z] [from-to] range
[^ab] anything in this world except a & b (inversion)
[xxx] match with set of characters (x, x, x are considered as separate pattern)
                                     ☝️
(xxx | xx) match with xxx or xx (not ☝️ like this at all)
r'(...)(...)' match.group(1) & match.group(2) to extract matches
r'xx(?:blahblahpattern)xx' to ignore a group in regex

{3,5} match repeatedly (3 to 5 matches exactly)
{3,}  match minimum 3 times
```
[watch this](https://youtu.be/saABx34CsBE?si=gJbMzXGIW9PQBw_C) before reading docs: dunno, probably it'll be good (~~didin't watch, m lazy~~)

> [!faq]- Greedy & Non-Greedy
> `.*?` & `.+?`
> ignore: the hell is "negative lookahead assertion" ?
## [Utilities](https://developers.google.com/edu/python/utilities)
subprocess - run powersheel / bash scripts

## Checkpoint
[up next](https://developers.google.com/edu/python/regular-expressions#basic-examples)
## Some rusty old notes
```python
class Fine:
	_var = "with a single _ I'm a static class variable and protected"
# __bases__ : list of base classes (in order)
# Operator Overloading:
# - .__add__(self, objOfClass), sub, mul, pow, truediv

# Sequence Type:
# - Strings 'immutable'
# - List     [mutable]
# - Tuple   (immutable)

# copying a list
l2=list(l) # copy
l2 = l     # reference

import copy
l2=copy.copy(l)     # shallow copy
l2=copy.deepcopy(l) # also nested lists are copied
l2=l[:]             # this is reference !!

# TUPLES
to=1, # comma for one element
tt=1,2,3,4,5,6,7,8
result=tt,to # Nested tuple - tt + to for concatenation
result[::-1] # -1 steps, ie reverse on displaying
del tt # delete tuple
len(result)
tuple('cool') # ('c', 'o', 'o', 'l') : Tuple

# {Dictionary} k:v pairs, keys are unique
# values - *anything* : keys - should be immutable type
dict={1:'futatsu?', 2:'itoutsu?'}
dict[1] # Access elements
dict[1] = 'first' # updation
dict.pop(2)
dict.popitem() # del last added K:V - returns tuple
```
tip: avoid inline comments ^
## Tips from [bootcamp](https://justinbois.github.io/bootcamp/2020_fsri/lessons/l13_intro_to_pandas.html)
tip 2: If you are writing code and you think to yourself, “This seems like a pretty common things to do,” there is a good chance the someone really smart has written code to do it. If it’s something numerical, there is a good chance it is in NumPy or SciPy. **Use these packages.** Do not reinvent the wheel.
```python
for idx, base in enumerate(seq) # instead of range(len(seq))
*a_tuple # unpack operator
def concatenate_sequences(a, b, **kwargs): 
concatenate_sequences(**a_dict)
# kwargs is a dict (**) treat them as dict and iterate
```
### Grouping imports
1. standard library imports
2. related third party imports
3. local application/library specific imports
You should put a blank line between each group of imports.

### numpy
- vectorization, boolean indexing on **Series**
- split - apply - combine

## TDD: pytest
- start function name with '**test_**' and run pytest command and have assert statements
- for raising errors, you need to raise in main function + pytest.raises() in test cases.
- remove old test cases from time to time
## Forks
![[Pasted image 20231130151847.png]]
