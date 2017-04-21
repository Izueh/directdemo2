from pymongo import MongoClient
# from cassandra.cluster import Cluster
from gridfs import GridFS

client = MongoClient('dbrouter',27017)
db = client.twitter
fs = GridFS(db)

#cluster = Cluster(['cassandra'])
#cassandra = cluster.connect('dirdemo')
