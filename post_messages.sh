#!/bin/bash

# Check if number of arguments is correct
if [[ "$#" -ne 3 ]]; then
    echo "nok: usage: ./post_messages <sender> <receiver> <message>"
    exit 1
fi

# Assign arguments to variables
sender=$1
receiver=$2
message=$3

# Check if the sender exists
if ! [[ -d "users/$sender" ]]; then
    echo "nok: sender '$sender' does not exist"
    exit 1
fi

# Check if the receiver exists
if ! [[ -d "users/$receiver" ]]; then
    echo "nok: sender '$receiver' does not exist"
    exit 1
fi

# Check if sender is a friend of receiver
if ! grep "^$sender" "users/$receiver/friends.txt" > /dev/null; then
    echo "nok: user '$sender' is not a friend of '$receiver'"
    exit 1
fi

# Write the post into the receiver's wall
echo "$sender: $message" >> "users/$receiver/wall.txt"
echo ok: message posted
exit 0
