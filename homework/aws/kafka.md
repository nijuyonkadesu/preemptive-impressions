## usecase 
- non scalable internal storage[with expiry]

## Architecture
- [Brokers] stores the actual data [distributed] + **leader** election
- grouped as [cluster]
- consensus manager [zookeeper] basically, etcd3
- producer can also be a consumer

## Workings 
### pub/sub

[topic [partitions...]]
- data written to single partion [leader]
- other partition will sync soon
- at it's core, it's a [log] processing system

## partitions
- 0 indexed [replicated]
- advised to have a little offset window

- tf is rebalance
- within partiton, [order] is guarenteed, across group it's not (because, you try to read old message if consumer fails inside a consumer group)
- no duplicates of message
- data can still be lost, fully dependent on [leader]

- only inline upgrades. No [rollbacks]. So test well in local before pushing into production
- glue mention [schema] and migrate data

## Practices
- right size cluster
- 15% util = serverless
- set alarms @85%
- no of partition per topic = max injest rate per topic in MBps / 2
- per broker <4k partitions

## Metrics
- ActiveControllerCount
- BytesInPerSec and BytesOutPerSe
- CPU user (shdn't go beyond 60%)
- KafkaDataLogsDiskUsed
- Leader Count
- PartitioinCount

## Security
- https://www.rfc-editor.org/rfc/rfc5802
- SASL Salted Challenge Response Authentication Mechanism (SCRAM)
- SASL Generic Security Services Application Program Interface (GSSAPI)
- SASL OAUTHBEARER (SASL mechanism for OAuth 2)
- TLS Mutual

## Curious
- cellular architecture
