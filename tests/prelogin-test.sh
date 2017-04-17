#Test that API calls require login

#additem
echo "Testing additem (WITHOUT parent or media)"
response=$(curl localhost/additem -d '{"content":"test tweet", "type":"inventory"}' -H "Content-Type: application/json" -b saved-cookie)
itemid=$(jq -r '.id' <<< $response)
status=$(jq -r '.status' <<< $response)
echo "id: $itemid"
if [ "$status" = "error" ]
then
    echo -e "\e[32mGot status: 'error' as expected"
else
    echo -e "\e[31mGot status: $status"
    echo $response
fi
echo -e "\e[39m"

#get item
echo "Testing get item"
echo "curl localhost/item/$itemid"
response=$(curl localhost/item/$itemid -b saved-cookie)
status=$(jq -r '.status' <<< $response)
if [ "$status" = "error" ]
then
    echo -e "\e[32mGot status: 'error' as expected"
else
    echo -e "\e[31mGot status: $status"
    echo $response
fi
echo -e "\e[39m"

#additem with parent
echo "Testing additem with parent"
content=$(curl localhost/additem -d '{"content":"test reply", "type":"inventory", "parent":'"\"$itemid\""'}' -H "Content-Type: application/json" -b saved-cookie)
itemid=$(jq -r '.id' <<< "$content")
status=$(jq -r '.status' <<< $response)
if [ "$status" = "error" ]
then
    echo -e "\e[32mGot status: 'error' as expected"
else
    echo -e "\e[31mGot status: $status"
    echo $response
fi
echo -e "\e[39m"

#search 
echo "Testing search with no options"
response=$(curl localhost/search -d '{}' -H "Content-Type: application/json" -b saved-cookie)
status=$(jq -r '.status' <<< $response)
if [ "$status" = "error" ]
then
    echo -e "\e[32mGot status: 'error' as expected"
else
    echo -e "\e[31mGot status: $status"
    echo $response
fi
echo -e "\e[39m"

echo "Testing search with following=false"
response=$(curl localhost/search -d '{"following":"false"}' -H "Content-Type: application/json" -b saved-cookie)
status=$(jq -r '.status' <<< $response)
if [ "$status" = "error" ]
then
    echo -e "\e[32mGot status: 'error' as expected"
else
    echo -e "\e[31mGot status: $status"
    echo $response
fi
echo -e "\e[39m"

#like
echo "Testing like"
echo "curl localhost/item/$itemid/like"
response=$(curl localhost/$itemid/like -X POST -b saved-cookie)
status=$(jq -r '.status' <<< $response)
if [ "$status" = "error" ]
then
    echo -e "\e[32mGot status: 'error' as expected"
else
    echo -e "\e[31mGot status: $status"
    echo $response
fi
echo -e "\e[39m"

#add media
echo "Testing add media"
response=$(curl localhost/addmedia -F content=<../nbc-fires-donald-trump-after-he-calls-mexicans-rapists.jpg -b saved-cookie)
itemid=$(jq -r '.id' <<< "$response")
status=$(jq -r '.status' <<< $response)
if [ "$status" = "error" ]
then
    echo -e "\e[32mGot status: 'error' as expected"
else
    echo -e "\e[31mGot status: $status"
    echo $response
fi
echo -e "\e[39m"

#get media
echo "Testing get media"
response=$(curl localhost/media/$itemid -b saved-cookie)
status=$(jq -r '.status' <<< $response)
if [ "$status" = "error" ]
then
    echo -e "\e[32mGot status: 'error' as expected"
else
    echo -e "\e[31mGot status: $status"
    echo $response
fi
echo -e "\e[39m"

#additem with media
echo "Testing additem with parent and media"
response=$(curl localhost/additem -d '{"content":"test reply", "type":"inventory", "media":'"[\"$itemid\"]"'}' -H "Content-Type: application/json" -b saved-cookie)
itemid=$(jq -r '.id' <<< "$response")
status=$(jq -r '.status' <<< $response)
if [ "$status" = "error" ]
then
    echo -e "\e[32mGot status: 'error' as expected"
else
    echo -e "\e[31mGot status: $status"
    echo $response
fi
echo -e "\e[39m"

#logout
echo "Testing logout"
response=$(curl localhost/logout -X POST -b saved-cookie)
status=$(jq -r '.status' <<< $response)
echo $response
if [ "$status" = "error" ]
then
    echo -e "\e[32mGot status: 'error' as expected"
else
    echo -e "\e[31mGot status: $status"
    echo $response
fi
echo -e "\e[39m"

