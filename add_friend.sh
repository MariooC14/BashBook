#!/bin/bash

# Check if user id and friend id is provide
if [ -z "$1" ] || [ -z "$2" ]; then
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

# Check if friend and user are the same person
if [[ $user == $friend ]]; then
    echo "nok: self-friending is not permitted"
    exit 1
fi


# Add the add_lock here
if ! [ -f "locks/add_$user.txt" ]; then
    echo lock > "locks/add_$user.txt"
fi
if ! [ -f "locks/add_$friend.txt" ]; then
    echo lock > "locks/add_$friend.txt"
fi
# ./acquire_add.sh $user $friend


# Check if the user is friends with friend
# As BashBook forces mutual friendships we only check for one side
if grep "^$friend" "users/$user/friends.txt" > /dev/null; then
    echo "nok: '$friend' and '$user' are already friends"
else
    # Add both users to eachothers friends
    echo $friend >> "users/$user/friends.txt"
    echo $user >> "users/$friend/friends.txt"
    echo "ok: friend added!"
fi

# Release the lock
# ./release $user $friend