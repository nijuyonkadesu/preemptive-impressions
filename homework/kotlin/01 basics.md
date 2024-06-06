# Standard Library
- kotlin.math

# String
```kotlin
.uppercase()
.startsWith('l') // or double quote
.reversed()
.split()
val list = listOf("123", "45")
println(list.flatMap { it.toList() }) // [1, 2, 3, 4, 5] 
```
# Infix operators
in: checks for item in an iterable

```kotlin
in // check availability
to // create pair, map entry
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
## Progressions
Progressions have three essential properties: the `first` element, the `last` element, and a non-zero `step`. The first element is `first`, subsequent elements are the previous element plus a `step`. Iteration over a progression with a positive step is equivalent to an indexed `for` loop in Java/JavaScript.
```kotlin
println((1..10).filter { it % 2 == 0 })
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
.sortedBy { it.first }
.sortedBy { it.length }
.sortedWith {  }
.addAll()
.count()
.sum()
.map()
val deepArray = arrayOf(
    arrayOf(1),
    arrayOf(2, 3),
    arrayOf(4, 5, 6)
)
println(deepArray.flatten()) 
// [1, 2, 3, 4, 5, 6]
```
## Group and folding

one of group-and-fold using key selector.
if iterable: fold takes **'initialValue'**, then a **'accumulator'** (acc, element)
if grouping: fold takes **'initialValueSelector'**, then a **'accumulator'** (key, acc, element)
[docs](https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.collections/fold.html)
grouping happens on the fly, it is intermediate I believe.

```kotlin
.fold { 1, (acc, element) -> acc }
.fold (1) { acc, element -> acc + element }
.eachCount()
.eachCountTo(somePartialCounting.toMutableMap()) // continue counting from x

val fruits = listOf("cherry", "blueberry", "citrus", "apple", "apricot", "banana", "coconut")

val fruitBasket = fruits.groupingBy { it.first() }
    .fold({ key, _ -> key to mutableListOf<String>() },
		     //  ^ element  ^^^^^ x to x is a pair, unless wrapped with mapOf()
          { _, accumulator, element ->
              accumulator.also { (_, list) ->  list.add(element) }
          }) // ^ pair  ------->  ^ destructuring 
             // btw, this approach looks beautiful with streaming data

// much simpler - trailing lambda syntax
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
.toSortedMap()

// Returns a list to iterate upon
.entries
.keys
.values
.associate {  }
 val sortedEvenFruits = evenFruits.entries
        .sortedWith { a, b ->
            b.value.count() - a.value.count()
        } // Single Abstracted Method (SAM) - comparator
    println(sortedEvenFruits)
    
// Iterating, and val cannot be reassigned 
val charCodes = intArrayOf(72, 69, 76, 76, 79)
val byCharCode = charCodes.associate { it to Char(it) }

byCharCode.forEach { code, char ->
    println("code: ${code}, char: ${char}")
}
byCharCode.entries.forEach { entry ->
	println("code: ${entry.key}, char: ${entry.value}")
}
for (charCode in byCharCode){
    println(charCode.key)
}
for ((code, char) in byCharCode){
    println(char)
}
val map = mapOf("122" to 2, "3455" to 3)
println(map.flatMap { (key, value) -> key.take(value).toList() }) 
// [1, 2, 3, 4, 5] - but why... it's cool tho
```
# Sequence
are zippable.
The sequence produces values until it encounters first `null` value. If [seed](https://kotlinlang.org/api/core/kotlin-stdlib/kotlin.sequences/generate-sequence.html) is `null`, an empty sequence is produced. Interesting...
```kotlin
val charCodes = intArrayOf(72, 69, 76, 76, 79)
val byCharCode = charCodes.associate { it to Char(it) }
val characters = generateSequence(1) { it * 2 + 1 }

val zipped = charCodes.asSequence().zip(characters) { a,b -> "$a/$b" }
zipped.forEach {
    println(it)
}

var count = 3

val sequence = generateSequence {
    (count--).takeIf { it > 0 } // will return null, when value becomes non-positive,
    // and that will terminate the sequence
}

println(sequence.toList()) // [3, 2, 1]
sequence.forEach {  }  // <- iterating that sequence second time will fail 
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
```