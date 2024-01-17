## AWS version of Apache Lucene
2 usecases **(search and log analytics [timeseries lifecycles])**  
inverted index - apache lucene  
token -> [posting list]  
BM 25 - scoring  
  
observability - (missed packet tracing): detect, investigate, revert: also distributed. 

Ingestion using pipeline (firehose) [aggregator]

m6g < r6g (EBS) < r6gd (instance storage, more throughput)
one domain per region

*Cluster Node has a state*
req (create idx) -> load balancer -> coord node -> distribute to nodes that have the data -> update shards -> wait for green signal across all nodes (create idx, low lvl activity **no scores are made yet. but yes, there is local scoring** ) -> to load balancer -> res

Production Rule: *domain in VPC*
- cross cluster search 
- trace analysis
- anamoly detection
- 
### Some internals
- KNN / LTR, 
- custom dictionary, 
- log usecase [hot tier > ultra warm (s3 + attached to instance) > cold (s3, attachable to ultra warm)],
- 10-20-50 GB :shard size [search, log] 

## Search patterns
social media, ecommerce 
**Features** : 
- Free Text Search + natural language
- Relevance ranked [adjustable] BM 25
- compound queries [boolean logic]
- Faceted drilldown and filtering [aggregation]
- Fuzzy matches, wildcard, range [num, geo points]
- Hit Highlighting
- type ahead suggestion, auto completion

**Data Structure**:
 - Overview, Hits
 - nlog(n)
 - Mapping / Templating [data model]. only one for a index  `_doc` as key (type)
 - cannot modify data which is injected using a map [could be updated (like adding new fields)], cannot change the existing mapping
 - `"dynamic": "strict", ` to avoid field explosion
 - `"dynamic_template": "long", { "mapping": "integer" }` type casting like
 - on text fields, aggergation not possible 
 - mark text -> keyword (token-> posting list won't happen for keyword fields)
 - multiple fields are possible `"text, keyword"`
 - **arrays can CROSS TALK! YOU DON'T WANT THAT**, SO NEST THINGS [type: nested]
 - Gramming [Bi, Trigram, 1, 22, 333, ... ngram] <- for autocomplete

 - text -> **analyzer** -> search index
	 - tokenizer (whitespace), stopwords [remove them, for better relevancy scores]
	 - stemming [pick the common root] industry & industrial = industr (cannot add new word, but can be cut to the root word)

 - vector search: KNN for better search  [there's a plugin], or feed into elastics as vector [max 750 dimentions] to even expand this limit, use KNN
 - neural search: 
 - KNN search [search similarties], HNSW, IVF, blah blah
 - field weights `^4` four times relevancy
 - boost queries (entire query, not the entire field)
	 - **Score matters at the end**

## 1. Log analysis
- time series
- producers (apps) -> collectors / shippers [kinesis agent, cloudwatch] -> aggregators (trimming data before indexing) [logstash, fluentd, kinesis firehose] -> elastic search
- sns with lamda trigger bulk push api
- ~~Logstash runs in local HW~~

**Some practices:**
- set retension period
- rolling index pattern
- ISM policy: Index State Management [date / age never resets on moving hot -> warm] + 5 retries
-  log search indexes are heavy, so have one
- 32GB heap = 640 shards [upper limit] (<20 shards per GB heap)
- 3 shards = 3 nodes [why?!]
### Aliases
group indexes under a name

# Open Search Service 
## Security
- encryption, auth, author audit
- keys in KMS
- IAM role + sigv4 = STS -> Open search Service access
- FGAC
# Best Practices
1. Design OSS
	1. Bulk api - 3-5 MB
2. Architecting 
	1. Cloudfront (CDN, edge location) [presentatioin]
	2. Business Logic
	3. DB + OpenSearch [index only the necessary field]
3. Size: 
	1. **Disk Size** = src data x (1 + no of replicas) x (1 - indexing overhead) (1 - Linux reserved space) / (1 - OpenSearch Service overhead)
	2. Searrch: Source x 2 x1.1 x 1.15
	3. Log: Source / day x 2 x 1.1 x **retention** x 1.15
	4. Search: 100GiB of data needs 250GiB of storage
	5. Logs: 1TiB daily of source data needs 18TiB of storage for 7 days
	6. **Shard count** = idx size / target shard size
	7. **Template**
	8. **Usage adjustment** - vCPU = 1.5 * active shards
	9. **Scaling**
	10. **Avoid skew** - pick shard size that is divisible by both 3 & 6 (AZ count)
	11. dual write for disaster management
	12. monitor recommended alarms
	13. auto tune [increase queue size]
	14. reduce refresh_interval (who cares above that) - 60s
	15. slow logs investigate (edge cases) [whethere it's a expensive query, or if it's staying in queue because of low resources on nodes], [it is replacable], [10MiB] or so
- visualize data using discover in opensearch
- string = Text + Keyword
- look at dashboard, if something goes wrong, then deep dive
## Links
- https://www.elastic.co/webinars/elasticsearch-architecture-best-practices
- [arch](https://archive.is/20230916073336/https://medium.com/geekculture/elasticsearch-architecture-1f40b93da719)
- [Inverted Index](https://blog.devgenius.io/what-is-inverted-index-and-how-we-made-log-analysis-10-times-more-cost-effective-with-it-6afc6cc81d20)

## Interesting
- what is backporting 

