from pymongo import MongoClient
from cassandra.cluster import Cluster

client = MongoClient('dbrouter',27017)
db = client.twitter

cluster = Cluster(['cassandra'])
cassandra = cluster.connect('dirdemo')
