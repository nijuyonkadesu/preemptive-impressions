# Standard Library
- kotlin.math.PI
- 

# String
```kt
.uppercase()
.startsWith('l') // or double quote
```
# Infix operators
in: checks for item in an iterable

```kt
in
to
```
# Ranges
```kt
val digits = 0..9
val indices = 0 ..<10
val indices = 0 until 10 // exclusive right side

val alphabets = 'a'..'z'
val evenIndices = 0..10 step 2
val reversed = 10 downTo 0 // inclusive both sides
```

# List and MutableList
Note: look about extension functions
```kt
val color = "pink"
.first()
.last()
.add(pink) 
.remove(pink) // automatically finds and removes it
.addAll()
.count()

```

# Set
```kt
val color = "purple"
.add(color)
.remove(color)
```

# Map is JSON 
```kt
val vocab: Map<String, List<String>> = mapOf("words" to listOf("commerative", "reverence", "crestfallen"))
val word = "palpable"
.put(word)
.remove(word)
.containsKey(word)
.keys
.values
```
