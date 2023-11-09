#!/bin/bash

# This program takes two args: the user id and friend id
# Both locks are to be acquired, order does not matter
# Order the 2 locks by alphabetical order, e.g. bar lock before foo lock
# Wait untl you acquire the first lock
# Wait until you acquire the second lock
# Exit once you have both locks

# Store the locks locks/add_<id>.txt

if [ -z "$0" ] || [ -z "$1" ]; then
    echo "No user id or friend id provided"
    exit 1
fi

user="$0"
friend="$1"

# Declare the order in which locks are to be acquired
if [[ "$user" < "$friend" ]]; then
    lock1="locks/add_$user.txt"
    lock2="locks/add_$friend.txt"
else
    lock1="locks/add_$friend.txt"
    lock2="locks/add_$user.txt"
fi

# Wait to get lock 1
while ! ln "$lock1" "$0" 2>/dev/null; do
    sleep 1
done

# Then wait to get lock 2
while ! ln "$lock2" "$0" 2>/dev/null; do
    # Release lock 1 before retrying to avoid deadlock
    rm -f "$lock1"
    sleep 1
    while ! ln "$lock1" "$0" 2>/dev/null; do
        sleep 1
    done
done

exit 0