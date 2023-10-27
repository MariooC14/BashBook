#!/bin/bash

# Check if user id was provided
if [ "$1" == "" ]; then
    echo "nok: no identifier provided"
    exit 1
fi
user=$1

# Check if user exists
if ! [ -d "users/$user" ]; then 
    echo "nok: user '$user' does not exist" 
    exit 1
fi

# Start displaying the wall
echo "start_of_file"
cat < "users/$user/wall.txt"
echo "end_of_file"