for(var i=1;i<4;i++){
    sh.addShard("r"+i+"/dbserver-" + i + ":27017");
}
sh.enableSharding('twitter');
sh.shardCollection("twitter.user",{ username: "hashed"});
sh.shardCollection("twitter.items",{_id:"hashed"});
db = db.getSiblingDB('twitter');
db.user.createIndex({email:"hashed"});
db.items.createIndex({username:"hashed"})

