#!/bin/bash

# This program takes two args: the user id and friend id
# Both locks are to be acquired, order does not matter
# Order the 2 locks by alphabetical order, e.g. bar lock before foo lock
# Wait untl you acquire the first lock
# Wait until you acquire the second lock
# Exit once you have both locks

# Store the locks locks/add_<id>.txt

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "No user id or friend id provided"
    exit 1
fi

user="$1"
friend="$2"

# Declare the order in which locks are to be acquired
if [[ "$user" < "$friend" ]]; then
    lock1="locks/add_$user"
    lock2="locks/add_$friend"
else
    lock1="locks/add_$friend"
    lock2="locks/add_$user"
fi

# Wait to get lock 1
while ! ln "$lock1.txt" $lock1 2>/dev/null; do
    sleep 0.5
done

# Then wait to get lock 2
while ! ln "$lock2.txt" $lock2 2>/dev/null; do
    sleep 0.5
done

exit 0