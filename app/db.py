from pymongo import MongoClient
from cassandra.cluster import Cluster

client = MongoClient('192.168.1.31',27017)
db = client.directdemocracy

cluster = Cluster(['130.245.168.171'])
cassandra = cluster.connect('dirdemo')
