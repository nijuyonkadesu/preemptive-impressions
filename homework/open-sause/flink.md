# Usecase

1. emulate exactly once business operation
2. typically used with kafka topics (w/ partitioned), because:
   - kafka is fault tolerant
   - kafka offers replayablility
   - kafka transactions
3. flink has checkpoint and it is stateful
   - combine all [CDC - kafka] pipelines into a centralized store to avoid DB network calls.
   - process and flush to DB of choice
   - DB calls are expensive and unwanted recomputation (filter on a ID)
4. Internally uses rocksdb (LSM + SST) for faster writes

```js
Raw table: (CDC)
1 | 10
1 | 23
1 | 9

。。。。。。。。
[ Kafka Topic ]
。。。。。。。。

Derived Table: (out from flink) (result of precomputation)
1 : { 10, 23, 9 }
```

# Benefits

- no partial failure scenario (db - cache consistency)
- avoid 2 phase commits
- avoid doing traditional write through caching

# Examples

1. Designing news feeds with users & followers.
2. indirectly join tables on a streaming environment.

# Configuration

1. proper partitioning
2. sharding
