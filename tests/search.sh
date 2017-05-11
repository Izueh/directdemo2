#Login and test search

#login
echo "Testing login"
response=$(curl localhost/login -d '{"username":"testuser", "password":"testpass"}' -H "Content-Type: application/json" -c saved-cookie)
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
    echo $response
else
    echo -e "\e[31mDidn't get status: 'OK'"
    echo $response
fi
echo -e "\e[39m"

echo "Testing search with following=False"
response=$(curl localhost/search -d '{"following":"false", "q":"tweet"}' -H "Content-Type: application/json" -b saved-cookie)
status=$(jq -r '.status' <<< $response)
if [ "$status" = "OK" ]
then
    echo -e "\e[32mGot status: 'OK'"
    echo $response
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

