## This is what hooked me in:

[referece: how programming language creators abused NaN (not a number) for SPEED](https://youtu.be/Rc8J7NW4l0Y?si=JIYKqeeWXw84tNh9) 
[reference: bits are high level](https://youtu.be/i-h95QIGchY) 

# Monologues

how can you interpret 0b000000100 as a 3x4 (rowsxcols) rectangle that takes one value of

00 01 02 03
10 11 12 13
20 21 22 23

---

(0, 1, 2, 3) are from the last 2 bits. (the 2nd bit in 01, 02, 03).
(0, 1, 2) are from the next 2 bits from the last. (the 1st bit in 00, 10, 20).

The author explains bits are flexible, its upto the program to interpret the same value in a differnt format in differnt parts of the code,... but I don't understand how can it be done

|: **glue**. to group all the set bits together, like **overlapping** different binaries, if a bit is set, the final result will always have it set.
&: **extract** specific bit(s) (by turning on corresponding bits to 1 in a number) from LSB -> MSB. The operation of choice for masking.
~: flip all the bits

In [85]: encoded = 0b10101101

In [86]: x = encoded & 0b11
In [88]: bin(x)
Out[88]: '0b1'

In [92]: y = (encoded & 0b1100) >> 2
In [93]: bin(y)
Out[93]: '0b11'

they extract the corresponding values from a big number, and interpret it as a coordinate.
so that, the coordinate can now point any value from a 4x3 rectangle.

or 4x2 rectangle
or 4x4 rectangle (max dimension) based on however they want to interpret the numbers as.

in my example, the coord is: (1, 3).

but what happens when the extracted number points to 3,3? (when my application don't have a meaning for 3,3 or 3,4?

TODO: really understand how the tree interpretation differs from the clean separation of dimensions.
TODO: `n*m` if interpreted as tree, and `n+m` if interpreted as clean separation of dimensions?? I kinda get it, but how exatly? 2x2 as a "dimension", and cases separately for it, rather than mixing different dimension and mess up the execution flow?

```cpp

static inline UB
outer_type_from_type(Type const *type, TypeKind outer_kind)
{
    UPtr kind_o = MSB32(outer_kind)
    UPtr type_ptr = (UPtr)type;

    return (kind_0 & 0x1f) | (type_ptr << 5);
}
```

| Bit Index              | 7   | 6   | 5   | **4** | 3   | 2   | 1   | 0   |
| :--------------------- | :-- | :-- | :-- | :---- | :-- | :-- | :-- | :-- |
| **Value (0b11010000)** | 1   | 1   | 0   | **1** | 0   | 0   | 0   | 0   |
| **Mask (~0x1f)**       | 1   | 1   | 1   | **0** | 0   | 0   | 0   | 0   |
| **Result (&)**         | 1   | 1   | 0   | **0** | 0   | 0   | 0   | 0   |



