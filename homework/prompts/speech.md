# transcript_to_shadowing.md

## Purpose

Given a normal English transcript (from a video, podcast, interview, etc.), create a second version optimized for shadowing and rhythm practice.

The output should help a learner develop:

1. Stress timing
2. Sentence stress
3. Reductions
4. Native-like rhythm

The goal is NOT IPA accuracy or dictionary pronunciation.

The goal is to show how native speakers naturally emphasize and reduce words during connected speech.

---

# Principles

## 1. Content words receive stress

Stress these words by writing the stressed syllable in UPPERCASE.

Content words include:

* nouns
* verbs
* adjectives
* adverbs
* negatives

Examples:

Normal:

> Last week I decided to change my morning routine.

Shadowing:

> LAST WEEK I deCIDed to CHANGE my MORNing rouTINE.

---

## 2. Function words shrink

Function words are usually reduced:

* to
* the
* a
* an
* of
* for
* and
* are
* was
* have
* has
* had
* can
* could
* should
* would

Do not stress these words.

Optionally annotate them with common reductions.

Example:

Normal:

> I'm going to the store.

Shadowing:

> I'm GOing tə thə STORE.

or

> I'm GOing
>
> tə thə
>
> STORE

Common reductions:

| Word | Reduced Form |
| ---- | ------------ |
| to   | tə           |
| the  | thə          |
| a    | ə            |
| and  | ən           |
| of   | əv           |
| for  | fər          |
| are  | ər           |
| was  | wəz          |
| have | həv          |
| has  | həz          |
| can  | kən          |

Use simple schwa notation.

Avoid full IPA unless necessary.

---

## 3. Highlight only stressed syllables

Do NOT capitalize entire words.

Good:

> deCIDed

Bad:

> DECIDED

Good:

> aBOUT

Bad:

> ABOUT

---

## 4. Group by thought units

Break long sentences into chunks.

Example:

Normal:

> At first it felt a little strange because I was so used to scrolling through messages and news updates.

Shadowing:

> At FIRST
>
> it felt a little STRANGE
>
> because I was so USED to
>
> SCROLLing through MESSages
>
> and NEWS upDATES.

The purpose is to make the rhythm visible.

---

## 5. Show reductions only where native speakers actually reduce

Good:

> I WANNA go tə thə STORE.

Good:

> I've GOTTA finish this.

Good:

> Whaddaya MEAN?

Bad:

> Every single word rewritten phonetically.

Readability is more important than accuracy.

---

# Output Format

Input:

> I want to go to the store after work.

Output:

```text
I WANT
tə

GO
tə thə STORE

after WORK
```

Expanded:

```text
I WANT tə GO tə thə STORE after WORK.
```

---

# Examples

## Example 1

Input:

> I'm going to the store.

Output:

```text
I'm GOing

tə thə

STORE
```

Expanded:

```text
I'm GOing tə thə STORE.
```

---

## Example 2

Input:

> What are you doing?

Output:

```text
Whaddaya

DOing?
```

Expanded:

```text
Whaddaya DOing?
```

---

## Example 3

Input:

> I have to finish this today.

Output:

```text
I HAFta

FINish this

təDAY.
```

Expanded:

```text
I HAFta FINish this təDAY.
```

---

## Example 4

Input:

> Last week I decided to change my morning routine.

Output:

```text
LAST WEEK

I deCIDed tə

CHANGE my

MORNing rouTINE.
```

Expanded:

```text
LAST WEEK I deCIDed tə CHANGE my MORNing rouTINE.
```

---

## Example 5

Input:

> At first it felt a little strange.

Output:

```text
At FIRST

it felt a little STRANGE.
```

Expanded:

```text
At FIRST it felt a little STRANGE.
```

---

# Rules

1. Stress only content words.
2. Show stressed syllables with UPPERCASE.
3. Shrink function words using common reductions.
4. Group sentences into thought units.
5. Prefer readability over IPA precision.
6. Mimic conversational American English rhythm.
7. Avoid over-marking.
8. The result should look like musical notation for speech.
9. Preserve original wording.
10. Optimize for shadowing practice rather than phonetic correctness.

---

# Desired Output Style

Input:

> I didn't say he stole the money.

Output:

```text
I DIDn't say

he STOLE

the MONEY.
```

Expanded:

```text
I DIDn't say he STOLE thə MONEY.
```

The rhythm should be immediately visible at a glance.

