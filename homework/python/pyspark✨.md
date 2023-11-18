It's an analytical engine for large scale data processing. It's a better **MapReduce** (in mem),... okok
- Turn on history server to see past Jobs and it's runtime
- [colab](https://colab.research.google.com/drive/1Q6hZBX-M4ZXJZq0SNlfXQXyVCR_wORTh?usp=sharing) file - but unable to fix ~

# RDD - Resilient Distributed Database
- [Just read this](https://sparkbyexamples.com/pyspark-tutorial/)
- fault-tolerant, immutable distributed collections of objects
- one spark context per JVM
- similar to panda's DataFrame
	- Transformations - returns new RDD - `flatMap(), map(), reduceByKey(), filter(), sortByKey()`
	- actions - triggers computation and return RDD to the *Driver* - `count(), collect(), first(), max(), reduce()`
- practice: [PySparkSQL](https://sparkbyexamples.com/pyspark/pyspark-sql-with-examples/)

---
