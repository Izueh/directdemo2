#adduser
echo "Testing adduser {username: testuser, password: testpass, email: testemail}"
curl localhost/adduser -d '{"username":"testuser", "password":"testpass", "email":"testemail"}' -H "Content-Type: application/json"
echo ""

#verify
echo "Testing verify"
curl localhost/verify -d '{"email":"testemail", "key":"abracadabra"}' -H "Content-Type: application/json"
echo ""

#login
echo "Testing login"
curl localhost/login -d '{"username":"testuser", "password":"testpass"}' -H "Content-Type: application/json" -c saved-cookie
echo ""

#additem
echo "Testing additem (WITHOUT parent or media)"
content=$(curl localhost/additem -d '{"content":"test tweet", "type":"inventory"}' -H "Content-Type: application/json" -b saved-cookie)
itemid=$(jq -r '.id' <<< "$content")
echo "id:" $itemid
echo ""

#get item
echo "Testing get item"
echo "curl localhost/item/$itemid"
curl localhost/item/$itemid -b saved-cookie
echo ""

#additem with parent
echo "Testing additem with parent"
content=$(curl localhost/additem -d '{"content":"test reply", "type":"inventory", "parent":'"\"$itemid\""'}' -H "Content-Type: application/json" -b saved-cookie)
itemid=$(jq -r '.id' <<< "$content")
echo ""


#search 
echo "Testing search with no options"
curl localhost/search -d '{}' -H "Content-Type: application/json" -b saved-cookie
echo ""

#like
echo "Testing like"
echo "curl localhost/item/$itemid/like"
curl localhost/$itemid/like -X POST -b saved-cookie
echo ""

#add media
echo "Testing add media"
content=$(curl localhost/addmedia -F content=<../nbc-fires-donald-trump-after-he-calls-mexicans-rapists.jpg -b saved-cookie)
itemid=$(jq -r '.id' <<< "$content")
echo ""

#get media
echo "Testing get media"
curl localhost/media/$itemid -b saved-cookie
echo ""

#additem with media
echo "Testing additem with parent and media"
content=$(curl localhost/additem -d '{"content":"test reply", "type":"inventory", "media":'"[\"$itemid\"]"'}' -H "Content-Type: application/json" -b saved-cookie)
itemid=$(jq -r '.id' <<< "$content")
echo ""

#logout
echo "Testing logout"
curl localhost/logout -X POST -b saved-cookie 
echo ""

