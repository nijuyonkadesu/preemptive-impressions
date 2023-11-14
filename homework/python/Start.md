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

## Regex
```python
match = re.search(r'word:\w\w\w', str) # r'xxx' is raw text
```
[watch this](https://youtu.be/saABx34CsBE?si=gJbMzXGIW9PQBw_C) before reading docs: dunno, probably it'll be good
## [Utilities](https://developers.google.com/edu/python/utilities)
subprocess - run powersheel / bash scripts

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