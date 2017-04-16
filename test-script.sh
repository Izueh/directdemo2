#adduser
echo "Testing adduser {username: testuser, password: testpass, email: testemail}"
curl localhost/adduser -d '{"username":"testuser", "password":"testpass", "email":"testemail"}' -H "Content-Type: application/json"

#verify
echo "Testing verify"
curl localhost/verify -d '{"email":"testemail", "key":"abracadabra"}' -H "Content-Type: application/json"

#login
echo "Testing login"
curl localhost/login -d '{"username":"testuser", "password":"testpass"}' -H "Content-Type: application/json" -c saved-cookie

#additem
echo "Testing additem (WITHOUT parent or media)"
content=$(curl localhost/additem -d '{"content":"test tweet", "type":"inventory"}' -H "Content-Type: application/json" -b saved-cookie)
itemid=$(jq -r '.id' <<< "$content")
echo "id:" $itemid

#logout
echo "Testing logout"
curl localhost/logout -X POST -b saved-cookie 

