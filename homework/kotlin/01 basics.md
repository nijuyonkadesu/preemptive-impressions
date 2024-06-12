# Standard Library
- kotlin.math

# Handy Defaults
```kotlin
Int.MAX_VALUE
Int.MIN_VALUE
.max()
.min()
```
# String
```kotlin
fun String.alphabetized() = String(toCharArray().apply { sort() })
.length
.uppercase()
.startsWith('l') // or double quote
.reversed()
.substring()
.replace()
.contains()
.split()
val list = listOf("123", "45")
list.flatMap { it.toList() } // [1, 2, 3, 4, 5] 
numbers.joinToString(prefix = "<", postfix = ">", separator = "•", limit = 5, truncated = "...!")
"%(d means %1\$d".format(-31416)
"%,d".format(Locale.US, 12345)
.trimIndent()
val a = """Trimmed to margin text:
          |if(a > 1) {
          |    return a
          |}""".trimMargin()
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
val bitMapLike = List(26) { 0 }
.size
.chunked(7) // [[xxx], [xxx]]
.takeLastWhile()
.binarySearch()
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
.take()
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
.size
.add(color)
.remove(color)
.addAll()
```

# Map is JSON 
```kotlin
val vocab: Map<String, List<String>> = mapOf("words" to listOf("commerative", "reverence", "crestfallen"))
val word = "palpable"
.put(word)
.remove(word)
.containsKey(word)
.toSortedMap()
.putIfAbsent(key, value)

// Returns a list to iterate upon
.entries
.keys
.values

// Add / update values on the go
map.compute(4) { key, value -> (value?.toInt() ?: 0) + 4 }
// update values on the go
map.computeIfPresent(4) { key, value -> value + 1 }

// to create a map from a collection 
.associate {  } // define both key and value using infix operator 'to'
.associateBy {  } // define the key, 'it' 'as is' is the value
.associateWith {  } // 'it' 'as is' is the key 

// ughhhh, when a predicate inside this baka turns true, it just everything what comes next without a second thought... could have just used a .filter { }
.dropWhile()
.drop()

 val sortedEvenFruits = evenFruits.entries
        .sortedWith { a, b ->
            b.value.count() - a.value.count()
        } // Single Abstracted Method (SAM) - comparator
    println(sortedEvenFruits)
    
// Iterating, and val cannot be reassigned 
val charCodes = intArrayOf(72, 69, 76, 76, 79)
val byCharCode = charCodes.associate { it to Char(it) }
.forEachIndexed { idx, ele -> }
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
When using an acronym as part of a declaration name, capitalize it if it consists of two letters (`IOStream`); capitalize only the first letter if it is longer (`XmlFormatter`, `HttpInputStream`).
- Factory classes are easy to make using `companion object`
```kotlin
fun Int.fine(): Double = toDouble() // 1.0
fun uglySum(vararg numbers: Int) = numbers.sum()
uglySum(1,2,3,4,5)

typealias MouseClickHandler = (Any, MouseEvent) -> Unit
typealias PersonIndex = Map<String, Person>

// internal use only
private val _elementList = mutableListOf<Element>()
// exposed public readonly version
val elementList: List<Element>
	 get() = _elementList

// Do not use a labeled return for the last statement in a lambda.
ints.forEach lit@{
        // ...
    }
```
## Extentions 
- use local extenstion functions
- Top-Level Extension Functions with Private Visibility (File level)
- if function primarily works with only one object, make it to an extension function
## Infix
Declare a function as infix only when it works on two objects which play a similar role. Good examples: `and`, `to`, `zip`. Bad example: `add`.
```kotlin
infix fun <A, B> A.to(that: B): Pair<A, B> = Pair(this, that)
```
## Scope Functions
- Executing a lambda on non-nullable objects: `let`
- Introducing an expression as a variable in local scope: `let`
- Object configuration: `apply`
- Object configuration and computing the result: `run`
- Running statements where an expression is required: non-extension `run`
- Additional effects: `also`
- Grouping function calls on an object: `with`
further [reference](https://kotlinlang.org/docs/scope-functions.html#distinctions)
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

# Modifiers
```kotlin
public / protected / private / internal
expect / actual
final / open / abstract / sealed / const
external
override
lateinit
tailrec
vararg
suspend
inner
enum / annotation / fun // as a modifier in `fun interface`
companion
inline / value
infix
operator
data
```
# KClass
Main usecase comes when performing dependency injection. So don't touch and use Dagger ~.
Maybe this also uses platform types.
obtain a `KClass` instance using the `::class` syntax on a type or an instance.
# Null Safety
Declare variables with `?` at the end, these can be nullable.
`nullString?.length ?: 0` - elvis operator
# Templating
...

# Notes
[Extra Rules For Libraries](https://kotlinlang.org/docs/coding-conventions.html#coding-conventions-for-libraries)
[API Guidelines](https://kotlinlang.org/docs/api-guidelines-introduction.html)
[Spring Boot](https://kotlinlang.org/docs/jvm-create-project-with-spring-boot.html)
