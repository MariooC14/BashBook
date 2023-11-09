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

# Declare the order in which locks are to be acquired
if [ "$0" < "$1" ]; then
    lock1="locks/add_$0.txt"
    lock2="locks/add_$1.txt"
else
    lock1="locks/add_$1.txt"
    lock2="locks/add_$0.txt"
fi

# Wait to get lock 1
while ! ln "$0" "$1" 2>/dev/null; do
    sleep 1
done
# Then wait to get lock 2

exit 0