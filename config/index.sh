
echo [DELETING]
curl localhost:9200/twitter?pretty -XDELETE
echo [CREATING]
curl -H Content-Type: application/json localhost:9200/twitter?pretty -XPUT -d '{ "settings": { "index": { "number_of_shards":3, "number_of_replicas":0} } }'
echo [REFRESHING]
curl localhost:9200/twitter/_refresh?pretty
echo [MAPPINGS]
curl http://localhost:9200/twitter/_mapping/items?pretty -XPUT -d '{ "properties": { "content": { "type": "text"} } }'
curl http://localhost:9200/twitter/_mapping/items?pretty -XPUT -d '{ "properties": { "username": { "type": "keyword"} } }'
curl http://localhost:9200/twitter/_mapping/items?pretty -XPUT -d '{ "properties": { "timestamp": { "type": "double"} } }'
curl http://localhost:9200/twitter/_mapping/items?pretty -XPUT -d '{ "properties": { "interest_score": { "type": "long"} } }'
