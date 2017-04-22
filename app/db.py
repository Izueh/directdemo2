from pymongo import MongoClient
# from cassandra.cluster import Cluster
from gridfs import GridFS
from elasticsearch import Elasticsearch


client = MongoClient('loadbalancer',27017)
db = client.twitter
fs = GridFS(db)
es = Elasticsearch('search')
#cluster = Cluster(['cassandra'])
#cassandra = cluster.connect('dirdemo')
