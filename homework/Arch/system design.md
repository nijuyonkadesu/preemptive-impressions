# Postulates

## Trade-offs

- Performance vs Scalablity
- Latency vs Throughput
- Availability vs Consistency

## CAP

- you can only pick 2 from the 'CAP'
- CP and AP are the two types of systems

### Availability Pattern

- Fail-over + Fail-back
- Replication - Master-Slave, Master-Master

## Scalablity Pattern - [STATE]

- Partitioning
- HTTP Caching (Reverse Proxy)
- RDBMS Sharding
- Distributed Caching
- Concurrency
- Data Grids
- NoSQL

### RDBMS

- Scaleout - Sharding
  - Partitioning
  - Replication
- difficult to scale reads
- impossible to scale writes

### NoSQL

- [Key-Value (Voldemort), Column (cassandra), Document (mongo), Graph (neo4j), Datastructure (redis)]

### BASE

- Bacically Available, Soft state, Eventual consistency
- [Cassandra, Voldemort]

### Multinode Setup

- Chord and Pastry
  - Distributed Hash Table (DHT) for partitioning data
  - Popularized [Node Ring, Consistent Hashing]
  - Distributed Caching - [Write through, Write behind, P2P, eviction policies]
    - Write through: write to cache, and then write to DB
    - Write behind: write to cache, put in queue, finally write to DB by event processors
    - Eviction: TTL, Bounded FIFO/LIFO
    - P2P: Node can join and leave as they wish, decentralized

### Data Grids / Clustering

Parallel data storage

- Data replication, partition
- C + P in CAP

### Concurrency

- Shared-State Concurrency
  - any one is free to access any data
  - **need locks**, it's complex and error recovery is hard.
- Message-Passing Concurrency
  - Shares NOTHING, 0 shared state
  - lightweight, async processes,
  - (Actors) - avoid deadlocks, race conditions, starvation, live locks
- Dataflow Concurrency
  - Declarative
  - Lazy execution, blocks a thread
- Software Transactional Memory (STM)
  - relies on heap and memory
  - Atomic operations within an application

## Scalablity Pattern - [BEHAVIOUR]

- Event-Driven Architecture
- Compute Grids
- Load-balancing
- Parallel Computing

### Event-Driven Architecture

- Domain Events
- Event Sourcing
- Command and Query Responsibility Segregation (CQRS)
- Event Stream Processing
- Messaging: Standards - [AMQP (rabbitmq), JMS]
  - Publish-Subscribe
  - Point-to-Point: Simple queue
  - Store-forward
  - Request-Reply
- Enterprise Service Bus
- Actors
  - Fire and Forget
  - Fire and Receive Eventually (future / promises)
- Enterprise Integration Patterns

### Compute Grids

- Parallel Execution
  - Divide and conquer: Split up jobs into independent tasks, execute tasks in parallel, aggregate and return the result
  - MapReduce (Master/Worker)
  - Auto Provisioning + Fail-over + Load-balancing + topology resolution

### Load-balancing

- Round-robin
- Weighted allocation
- examples: hw: cisco, sw: nginx

### Parallel Computing

- SPMD - Single Program Multiple Data. Like SIMD Instructions?
- Master/Worker
  - work stealing
  - termination: queue empty / poision pill
  - fault-toleration: in-progress queue
- Loop Parallelism
- Fork/Join: when Master/Worker & Loop Parallelism fails
  - when relationship between tasks are simple
- MapReduce
  Execution Unit: [ Process, Thread, Coroutine, Actor ]

## Stability Patterns

- Timeouts
- Circuit Breaker
- Let-it-crash
  - Instead of preventing failures, manage it
  - Restart Strategy - One for One, All for One, Supervisor hierarchies
- Fail fast
  - avoid slow responses
- Bulkheads
- Steady State
- Throttling

## Extra:

- Server Side Consistency (NWR)
- W + R > N
- W + R <= N

---

# Actual Designs (2025-05-31)

## 1. Twitter / Reddit Architecture

[jordan](https://youtu.be/S2y9_XYOZsg?si=w9MhukV3foHRdGhf)

- I'm missing the point of newsfeed cache for popular posts.. (verified users)
  - the point of popular news feed is to prevent write amplification.
    - it's simply not feasible to write a popular post to all posts DB for all the users.
    - instead maintain a single copy in a separate cache, and make users fetch them separately
    - for that, we need users-verified followers chache. verified user information we can get from users service (new user, upgrade to verify, more followers) - any write is valid write for this streaming pipeline setup
    - verified = 1 copy per post
    - others = ~100 copies

## Links

- [system design fight club](https://systemdesignfightclub.com/)
