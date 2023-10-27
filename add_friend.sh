#!/bin/bash

# Check if number of parameters is correct
if [ $# -ne 2 ]; then
    echo "nok: Usage: add_friend <user_id> <friend_id>"
    exit 1
fi

if [ "$1" == "" ] || [ "$2 " == "" ]; then
    echo "nok: Usage: add_friend <user_id> <friend_id>"
    exit 1
fi

# Assign arguments to variables
user=$1
friend=$2

# Check if user exists
if ! [[ -d "users/$user" ]]; then
    echo "nok: user '$user' does not exist"
    exit 1
fi

# Check if friend exists
if ! [[ -d "users/$friend" ]]; then
    echo "nok: user '$friend' does not exist"
    exit 1
fi

# Check if the user is friends with friend
# As BashBook forces mutual friendships we only check for one side
if grep "^$friend" "users/$user/friends.txt" > /dev/null; then
    echo "nok: '$friend' and '$user' are already friends"
else
    # Add user to friends
    echo $friend >> "users/$user/friends.txt"
    echo $user >> "users/$friend/friends.txt"
    echo "ok: friend added!"
fi