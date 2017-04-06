from pymongo import MongoClient, ReadPreferences
client = MongoClient('192.168.1.31',27017)
db = client.directdemocracy
