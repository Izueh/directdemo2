#adduser
echo "Testing adduser {username: followuser, password: followpass, email: followemail}"
response=$(curl localhost/adduser -d '{"username":"followuser", "password":"followpass", "email":"followemail"}' -H "Content-Type: application/json")
status=$(jq -r '.status' <<< $response)
if [ "$status" = "error" ]
then
    echo -e "\e[32mGot status: 'error' (expected error, user already exists)"
else
    echo -e "\e[31mDidn't get status: 'error' (expected error, user already exists)"
    echo $response
fi
echo -e "\e[39m"

#verify
echo "Testing verify"
response=$(curl localhost/verify -d '{"email":"followemail", "key":"abracadabra"}' -H "Content-Type: application/json")
status=$(jq -r '.status' <<< $response)
if [ "$status" = "OK" ]
then
    echo -e "\e[32mGot status: 'OK'"
else
    echo -e "\e[31mDidn't get status: 'OK'"
    echo $response
fi
echo -e "\e[39m"

#login
echo "Testing login"
response=$(curl localhost/login -d '{"username":"followuser", "password":"followpass"}' -H "Content-Type: application/json" -c saved-cookie)
status=$(jq -r '.status' <<< $response)
if [ "$status" = "OK" ]
then
    echo -e "\e[32mGot status: 'OK'"
else
    echo -e "\e[31mDidn't get status: 'OK'"
    echo $response
fi
echo -e "\e[39m"

#additem
echo "Testing additem (WITHOUT parent or media)"
response=$(curl localhost/additem -d '{"content":"follow tweet", "type":"inventory"}' -H "Content-Type: application/json" -b saved-cookie)
itemid=$(jq -r '.id' <<< "$response")
status=$(jq -r '.status' <<< $response)
echo "id:" $itemid
if [ "$status" = "OK" ]
then
    echo -e "\e[32mGot status: 'OK'"
else
    echo -e "\e[31mDidn't get status: 'OK'"
    echo $response
fi
echo -e "\e[39m"

#get item
echo "Testing get item"
echo "curl localhost/item/$itemid"
response=$(curl localhost/item/$itemid -b saved-cookie)
status=$(jq -r '.status' <<< $response)
if [ "$status" = "OK" ]
then
    echo -e "\e[32mGot status: 'OK'"
else
    echo -e "\e[31mDidn't get status: 'OK'"
    echo $response
fi
echo -e "\e[39m"

#additem with parent
echo "Testing additem with parent"
content=$(curl localhost/additem -d '{"content":"follow reply", "type":"inventory", "parent":'"\"$itemid\""'}' -H "Content-Type: application/json" -b saved-cookie)
itemid=$(jq -r '.id' <<< "$content")
status=$(jq -r '.status' <<< $response)
if [ "$status" = "OK" ]
then
    echo -e "\e[32mGot status: 'OK'"
else
    echo -e "\e[31mDidn't get status: 'OK'"
    echo $response
fi
echo -e "\e[39m"

#search 
echo "Testing search with no options"
response=$(curl localhost/search -d '{}' -H "Content-Type: application/json" -b saved-cookie)
status=$(jq -r '.status' <<< $response)
if [ "$status" = "OK" ]
then
    echo -e "\e[32mGot status: 'OK'"
else
    echo -e "\e[31mDidn't get status: 'OK'"
    echo $response
fi
echo -e "\e[39m"

echo "Testing search with following=false"
response=$(curl localhost/search -d '{"following":"false"}' -H "Content-Type: application/json" -b saved-cookie)
status=$(jq -r '.status' <<< $response)
if [ "$status" = "OK" ]
then
    echo -e "\e[32mGot status: 'OK'"
else
    echo -e "\e[31mDidn't get status: 'OK'"
    echo $response
fi
echo -e "\e[39m"

#like
echo "Testing like"
echo "curl localhost/item/$itemid/like"
response=$(curl localhost/$itemid/like -X POST -b saved-cookie)
status=$(jq -r '.status' <<< $response)
if [ "$status" = "OK" ]
then
    echo -e "\e[32mGot status: 'OK'"
else
    echo -e "\e[31mDidn't get status: 'OK'"
    echo $response
fi
echo -e "\e[39m"

#add media
echo "Testing add media"
response=$(curl localhost/addmedia -F content=<../nbc-fires-donald-trump-after-he-calls-mexicans-rapists.jpg -b saved-cookie)
itemid=$(jq -r '.id' <<< "$response")
status=$(jq -r '.status' <<< $response)
if [ "$status" = "OK" ]
then
    echo -e "\e[32mGot status: 'OK'"
else
    echo -e "\e[31mDidn't get status: 'OK'"
    echo $response
fi
echo -e "\e[39m"

#get media
echo "Testing get media"
response=$(curl localhost/media/$itemid -b saved-cookie)
status=$(jq -r '.status' <<< $response)
if [ "$status" = "OK" ]
then
    echo -e "\e[32mGot status: 'OK'"
else
    echo -e "\e[31mDidn't get status: 'OK'"
    echo $response
fi
echo -e "\e[39m"

#additem with media
echo "Testing additem with parent and media"
response=$(curl localhost/additem -d '{"content":"follow reply", "type":"inventory", "media":'"[\"$itemid\"]"'}' -H "Content-Type: application/json" -b saved-cookie)
itemid=$(jq -r '.id' <<< "$response")
status=$(jq -r '.status' <<< $response)
if [ "$status" = "OK" ]
then
    echo -e "\e[32mGot status: 'OK'"
else
    echo -e "\e[31mDidn't get status: 'OK'"
    echo $response
fi
echo -e "\e[39m"

#logout
echo "Testing logout"
response=$(curl localhost/logout -X POST -b saved-cookie -c saved-cookie)
status=$(jq -r '.status' <<< $response)
if [ "$status" = "OK" ]
then
    echo -e "\e[32mGot status: 'OK'"
else
    echo -e "\e[31mDidn't get status: 'OK'"
    echo $response
fi
echo -e "\e[39m"

