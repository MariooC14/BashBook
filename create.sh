#!/bin/bash

# Only take one argument
if [ $# -lt 1 ]; then
    echo "nok: no identifier provided"
    exit 1;
fi

# Assign argument to
userId=$1;

# Check if user folder exists
if ! [ -d "users/$userId" ]; then
    # Create the folder
    userFolder="users/$userId"
    mkdir $userFolder
    touch "$userFolder/wall.txt"
    touch "$userFolder/friends.txt"
    echo ok: user created!
    exit 0
else
    echo "nok: user already exists"
    exit 1
fi