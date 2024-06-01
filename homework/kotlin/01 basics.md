# Standard Library
- kotlin.math
- 

# String
```kotlin
.uppercase()
.startsWith('l') // or double quote
.reversed()
.split()
```
# Infix operators
in: checks for item in an iterable

```kotlin
in
to
```
# Ranges
```kotlin
val digits = 0..9
val indices = 0 ..<10
val indices = 0 until 10 // exclusive right side

val alphabets = 'a'..'z'
val evenIndices = 0..10 step 2
val reversed = 10 downTo 0 // inclusive both sides
```

# List and MutableList
Note: look about extension functions
```kotlin
val colors = listOf("pink", "purple")
val pink = "pink"
.contains(pink)
.first()
.last()
.add(pink) 
.remove(pink) // automatically finds and removes it
.eachCount()
.addAll()
.count()
.sum()
.map()
```
## Group and folding

one of group-and-fold using key selector.
if iterable: fold takes **'initialValue'**, then a **'accumulator'** (acc, element)
if grouping: fold takes **'initialValueSelector'**, then a **'accumulator'** (key, acc, element)
[docs](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.collections/fold.html)
grouping happens on the fly, it is intermediate I believe.

```kotlin
.fold { 1, (acc, element) -> acc }

val fruits = listOf("cherry", "blueberry", "citrus", "apple", "apricot", "banana", "coconut")

val fruitBasket = fruits.groupingBy { it.first() }
    .fold({ key, _ -> key to mutableListOf<String>() },
		     //  ^ element  ^^^^^ x to x is a pair, unless wrapped with mapOf()
          { _, accumulator, element ->
              accumulator.also { (_, list) ->  list.add(element) }
          }) // ^ pair  ------->  ^ destructuring 
             // btw, this approach looks beautiful with streaming data

// much simpler
val fruitBasket = fruits.groupingBy { it.first() }
    .fold(listOf<String>()) { acc, e ->  acc + e  }

val sorted = evenFruits.values.sortedBy { it.first }
println(sorted) 
```

# Set
```kotlin
val color = "purple"
.add(color)
.remove(color)
```

# Map is JSON 
```kotlin
val vocab: Map<String, List<String>> = mapOf("words" to listOf("commerative", "reverence", "crestfallen"))
val word = "palpable"
.put(word)
.remove(word)
.containsKey(word)
.keys
.values
```

# Functions
```kotlin
fun uglySum(vararg numbers: Int) = numbers.sum()
uglySum(1,2,3,4,5)
```
## Scope Functions
```kotlin
.let {} // to operate on non-null objects - it
.run {} // initialization tasks on object - this (implicit this. before vars)
.also { it -> }//    - it
apply {} // - this
```
## Lamda
```kotlin
val numbers = listOf(1, 2, -3. 4, 5)
val positiveNumbers = numbers.filter { x -> x > 0 }
val negativeNumbers = numbers.filter { x -> x < 0 }
val numbers = listOf(1, -2, 3, -4, 5, -6)

val canThisBeUnsigned: (Int) -> Int = { -1 * it }
println(numbers.map { canThisBeUnsigned(it)} )

fun flipper(numbers: List<Int>, modifier: (Int) -> Int): List<Int> {
    return numbers.map { modifier(it) }
}

fun canThisBeUnsigned(n: Int): Int {
	return -1 * n
}

fun main() {
    val numbers = listOf(1, -2, 3, -4, 5, -6)
    val canThisBeUnsigned: (Int) -> Int = { -1 * it }
    
    println(flipper(numbers, ::canThisBeUnsigned))
}



// functions
.filter {  }
.map {  }
.
```