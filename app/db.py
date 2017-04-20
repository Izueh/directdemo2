from pymongo import MongoClient
from cassandra.cluster import Cluster

client = MongoClient('192.168.1.31',27017)
db = client.twitter

cluster = Cluster(['192.168.1.51'])
cassandra = cluster.connect('dirdemo')
