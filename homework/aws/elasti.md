## CODE
```bash
PUT /idx-plex-u-rated
{
  "settings": {
    "index": {
      "number_of_shards": 3,
      "number_of_replicas": 1
    }
  }
}
GET /idx-plex-u-rated
GET /idx-plex-u-rated/_search
GET /idx-plex-u-rated/_search?q=honky
GET idx-plex-u-rated/_search
{
  "query": {
    "term": {
      "directors.keyword": {
        "value": "Kanes Honkey"
      }
    }
  }
}
GET idx-plex-u-rated/_search
{
  "query": {
    "term": {
      "title": "transducers"
    }
  }
}
GET idx-plex-u-rated/_search
{
  "query": {
    "term": {
      "title": " ҈҈҈҉҉҉҉҈҈҈҈҈҉҉҉҉҈҈҈҉҉҉҈҈҈҉҉҉҈҈҈҈҉҉҉҉҉҉҉҉҉҉҉҉҉҉҉҉҉҉҉҉҉҉҉҉҉҉҉҉҉҉҉҈҈҈҈҈҈҈‌҉҉҉҉҈҈ًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًًٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍٍّّّّّّّّّّّّܑܑܑܑܑܑܑܑܑܑܑܑܑܑܑܑܑܑܑܑܑܑܑ๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊๊ܻܻܻܻܻܻܻܻܻܻ݆݆݆݆݆݆݆݆݆݆݆݆݆݆݆݆݆݆݆݆݆݆݆݆݆݆݆݆ܻܻࣩࣩࣩࣩࣩࣩ࣯ࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩࣩ֟֟֟֟֟֟֟֟֟֟֟֟֟֓֓֓֓֓֓֓֓֓֓֓֓֒֒֒֒֒֒֒֒֒֒֒֒֒֒֒֒֒֒֒֓֓֓֓֓֓֓֓֒֒֒֘֘֘֘֘֘֘֗֗֗֗֗֗֗֗֗֗֗֗֗֗֗ؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؖؕؕؕؕؕؕؕؕؕؕؕؖؖؖؖؖؖؖؖؖؖؖٞٞٞٞٞٞٞٞٞٞٞٞٞٞٞٞٞٞٞٞٞٞٞٞٞ٘ۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛۛܺܺܺܺܺܺܺܺ݉݉݉݉݊݊݊݊݊݊݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅݅ࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣧࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣨࣤࣤࣤࣤࣤࣤࣤࣤࣤࣤࣤࣤࣤࣤࣤࣤࣤࣤࣤࣤࣤࣤࣤࣤࣤࣤࣤࣤࣤࣤ์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์์๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋๋ືືືືືືືືືືືືືືືືືືືືືືືຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶຶ᪴᪴᪴᪴᪴᪴᪴᪴᪴᪴᪴᪴᪴᪴᪴"
    }
  }
}

POST idx-plex-u-rated/_search
{
  "query": {
    "simple_query_string": {
      "query": "Transducers Astolfo",
      "fields": ["title"]
    }
  }
}

GET /idx-plex-u-rated/_search
{
  "query": {
    "bool": {
      "should": [
        {
          "match": {
            "genres": "action"
          }
        },
        {
          "match": {
            "title": "wick"
          }
        },
        {
          "match": {
            "actors": "reeves"
          }
        }
      ]
    }
  }
}
GET /idx-plex-u-rated/_search?explain=true
{
  "query": {
    "bool": {
      "should": [
        {
          "match": {
            "genres": "action"
          }
        },
        {
          "match": {
            "title": "wick"
          }
        },
        {
          "match": {
            "actors": "reeves"
          }
        }
      ]
    }
  }
}
GET /idx-plex-u-rated/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "genres": "action"
          }
        },
        {
          "match": {
            "title": "wick"
          }
        },
        {
          "match": {
            "actors": "reeves"
          }
        }
      ]
    }
  }
}
GET /idx-plex-u-rated/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "actors": "reeves"
          }
        }
     ],
     "should": [
        {
          "match": {
            "title": "wick"
          }
        },{
          "match": {
            "genres": "action"
          }
        }
      ]
    }
  }
}
GET idx-plex-u-rated/_search
{
  "query": {
    "range": {
      "year": {
        "gt": 2014,
        "lt": 2016
      }
    }
  }
}
GET idx-plex-u-rated/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "range": {
            "year": {
              "gt": 2014,
              "lt": 2016
            }
          }
        },
        {
          "match": {
            "genres": "action"
          }
        }
      ]
    }
  }
}
GET idx-plex-u-rated/_search
{
  "query": {
    "multi_match": {
      "query": "ecchi",
      "fields": ["title","plot"]
    }
  }
}
GET idx-plex-u-rated/_search
{
  "query": {
    "multi_match": {
      "query": "ecchi",
      "fields": ["title^2","plot"]
    }
  }
}
POST idx-plex-u-rated/_search
{
  "query": {
    "function_score": {
      "query": {
        "multi_match": {
          "query": "ecchi",
          "fields": [
            "title"
          ]
        }
      },
      "functions": [
        {
          "field_value_factor": {
            "field": "rating",
            "missing": 0
          }
        }
      ]
    }
  },
  "sort": [
    {
      "_score": {
        "order": "asc"
      }
    }
  ]
}
GET idx-plex-u-rated/_search
{
  "aggs": {
    "term_agg": {
      "terms": {
        "field": "genres.keyword"
      }
    }
  },
  "size": 0
}
GET idx-plex-u-rated/_search
{
  "aggs": {
    "year": {
      "aggs": {
        "genre": {
          "terms": {
            "field": "genres.keyword",
            "order": {
              "_key": "asc"
            }
          }
        }
      }, 
      "terms": {
        "field": "year"
      }
    }
  },
  "size": 0
}

# Highlighting
GET idx-plex-u-rated/_search
{
  "query": { "match" : { "plot" : "siscon" }},
  "highlight" : {
        "pre_tags" : ["<tag1>", "<tag2>"],
        "post_tags" : ["</tag1>", "</tag2>"],
        "fields" : {
            "plot" : {}
        }
      }
}

# Mapping
GET idx-plex-u-rated/_mapping

# Fuzzy
GET idx-plex-u-rated/_search
{
    "query": {
        "fuzzy": {
            "title": {
                "value": "dark",
                "fuzziness": "AUTO",
                "max_expansions": 50,
                "prefix_length": 0,
                "transpositions": true,
                "rewrite": "constant_score"
            }
        }
    }
}

# Faceting
POST idx-plex-u-rated/_search
{
  "query": {
    "match": {
      "plot": "isakai"
    }
  },
  "aggs": {
    "Rating Filter": {
      "range": {
        "field": "rating",
        "ranges": [
          {
            "from": 1,
            "to": 3
          },
          {
            "from": 3,
            "to": 6
          },
          {
            "from": 6,
            "to": 10
          }
        ]
      }
    }
  }
}

# List analyser plugin 
GET _cat/plugins?v

# Ultrawarm migrate & back to hot
POST _ultrawarm/migration/idx-plex-u-rated/_warm
POST _ultrawarm/migration/idx-plex-u-rated/_hot


```
