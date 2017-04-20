for(var i =0;i<11;i++){
    sh.addShard("dbserver-" + i + ":27017");
}
sh.shardCollection("twitter.user",{ username: "hashed"});
sh.shardCollection("twiiter.items",{_id:"hashed"});
use twitter;
db.items.createIndex({email:"hashed"});
db.items.createIndex({content: "text"});
db.items.createIndex({interest_score: -1});
db.items.createIndex({timestamp: -1});
