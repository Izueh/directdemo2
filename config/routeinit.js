for(var i=1;i<4;i++){
    sh.addShard("r"+i+"/dbserver-" + i + ":27017");
}
sh.enableSharding('twitter');
sh.shardCollection("twitter.user",{ username: "hashed"});
sh.shardCollection("twitter.items",{_id:"hashed"});
sh.shardCollection("twitter.chunks",{files_id:1,n:1})
db = db.getSiblingDB('twitter');
db.user.createIndex({email:"hashed"});
db.items.createIndex({username:"hashed"})
db.items.createIndex({content: "text"});
db.items.createIndex({interest_score: -1});
db.items.createIndex({timestamp: -1});
db.items.createIndex({username:"hashed",content:"text"})

